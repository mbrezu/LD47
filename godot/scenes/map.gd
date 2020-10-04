extends Node2D

signal segment_deleted(size, tile_number)

var MapCell = load("res://scripts/map_cell.gd")

var tile_scenes = [
	preload("res://scenes/tiles/tile_1.tscn"),
	preload("res://scenes/tiles/tile_2.tscn"),
	preload("res://scenes/tiles/tile_3.tscn"),
	preload("res://scenes/tiles/tile_4.tscn"),
	preload("res://scenes/tiles/tile_5.tscn"),
	preload("res://scenes/tiles/tile_6.tscn"),
	preload("res://scenes/tiles/tile_7.tscn")
]

var edge_scenes = [
	preload("res://scenes/edges/edge_1.tscn"),
	preload("res://scenes/edges/edge_2.tscn"),
	preload("res://scenes/edges/edge_3.tscn"),
	preload("res://scenes/edges/edge_4.tscn"),
	preload("res://scenes/edges/edge_5.tscn"),
	preload("res://scenes/edges/edge_6.tscn"),
	preload("res://scenes/edges/edge_7.tscn"),
	preload("res://scenes/edges/edge_8.tscn")
]

# map, there's space for 16 rows by 24 columns
var _map = []
var _detect = []

func _ready():
	_initialize_map()
	_render_map()


func add_tile(row, column, tile_number):
	_map[row][column].tile_number = tile_number
	_add_tile_at(row, column, true)


func make_tile_instance(tile_number):
	return tile_scenes[tile_number - 1].instance()


func map_dump():
	for row in _map:
		var row_str = ""
		for cell in row:
			row_str += cell.str() + " "
		print(row_str)


func is_free(row, column):
	if not _is_inside(row, column):
		return false
	return _map[row][column].tile_number == 0


func is_edge(row, column):
	if not _is_inside(row, column):
		return false
	if _map[row][column].tile_number < 100:
		return false
	return true


func _is_inside(row, column):
	if row < 0 or column < 0:
		return false
	if row >= _map.size() or column >= _map[row].size():
		return false
	return true


func _initialize_map():
	_map = []
	_detect = []
	for _row_index in range(0, Consts.MAP_ROWS):
		var row = []
		var detect_row = []
		for _col_index in range(0, Consts.MAP_COLUMNS):
			row.append(MapCell.new(0))
			detect_row.append(false)
		_map.append(row)
		_detect.append(detect_row)
	for _row_index in range(0, Consts.MAP_ROWS):
		_map[_row_index][0].tile_number = 104
		_map[_row_index][Consts.MAP_COLUMNS - 1].tile_number = 105
	for _column_index in range(0, Consts.MAP_COLUMNS):
		_map[0][_column_index].tile_number = 102
		_map[Consts.MAP_ROWS - 1][_column_index].tile_number = 107
	_map[0][0].tile_number = 101
	_map[0][Consts.MAP_COLUMNS - 1].tile_number = 103
	_map[Consts.MAP_ROWS - 1][0].tile_number = 106
	_map[Consts.MAP_ROWS - 1][Consts.MAP_COLUMNS - 1].tile_number = 108
	_map[Consts.START_SQUARE_ROW][Consts.START_SQUARE_COLUMN].tile_number = 1


func _render_map():
	for row in range(0, _map.size()):
		for column in range(0, _map[row].size()):
			_add_tile_at(row, column, false)


func _add_tile_at(row, column, check_tetrominoes):
	var tile_number = _map[row][column].tile_number
	if tile_number == 0:
		return
	var tile = null
	if tile_number < 100:
		tile = tile_scenes[tile_number - 1].instance()
	else:
		tile = edge_scenes[tile_number - 101].instance()
	tile.position = Vector2(column * 8, row * 8)
	_map[row][column].tile_instance = tile
	add_child(tile)
	if check_tetrominoes:
		var tetrominoes = _detect_tetrominoes()
		for segment in tetrominoes:
			_delete_segment(segment)


func _delete_segment(segment):
	for pos in segment:
		_delete_cell(pos[0], pos[1])
	var pos1 = segment[0]
	emit_signal(
		"segment_deleted", 
		segment.size(), 
		_map[pos1[0]][pos1[1]].tile_number)


func _delete_cell(row, column):
	_map[row][column].tile_instance.queue_free()
	_map[row][column].tile_number = 0


func _detect_tetrominoes():
	_clean_detect()
	var results = []
	for row in range(_map.size()):
		for column in range(_map[row].size()):
			var has_something = _map[row][column].tile_number > 0
			var is_not_edge = _map[row][column].tile_number < 100
			var is_not_detected = not _detect[row][column]
			if has_something and is_not_edge and is_not_detected:
				var segment = _get_segment(row, column)
#				print("found segment", segment)
				if segment.size() >= 4:
					results.append(segment)
	return results


func _get_segment(row, column):
	var tile_number = _map[row][column].tile_number
	var result = []
	var queue = [[row, column]]
	while not queue.empty():
		var p = queue.pop_front()
		result.append(p)
		_detect[p[0]][p[1]] = true
		_try_push(p[0], p[1] + 1, queue, tile_number)
		_try_push(p[0] + 1, p[1], queue, tile_number)
		_try_push(p[0], p[1] - 1, queue, tile_number)
		_try_push(p[0] - 1, p[1], queue, tile_number)
	return result


func _try_push(row, column, queue, tile_number):
	if row < 0 or column < 0:
		return
	if row >= _map.size() or column >= _map[row].size():
		return
	if _detect[row][column]:
		return
	if _map[row][column].tile_number != tile_number:
		return
	queue.push_back([row, column])


func _clean_detect():
	for row in _detect.size():
		for column in _detect[row].size():
			_detect[row][column] = false

