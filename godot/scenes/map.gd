extends Node2D

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

# map, there's space for 16 rows by 24 columns
var _map = []


func _ready():
	_initialize_map()
	_render_map()


func add_random_tile(row, column):
	var tile_number = randi() % 7 + 1
	_map[row][column].tile_number = tile_number
	_add_tile_at(row, column)


func map_dump():
	for row in _map:
		var row_str = ""
		for cell in row:
			row_str += cell.str() + " "
		print(row_str)


func is_free(row, column):
	if row < 0 or column < 0:
		return false
	if row >= _map.size() or column >= _map[row].size():
		return false
	if _map[row][column].tile_number > 0:
		return false
	return true


func _initialize_map():
	_map = []
	for _row_index in range(0, 16):
		var row = []
		for _col_index in range(0, 24):
			row.append(MapCell.new(0))
		_map.append(row)
	_map[8][12].tile_number = 1


func _render_map():
	for row in range(0, _map.size()):
		for column in range(0, _map[row].size()):
			_add_tile_at(row, column)


func _add_tile_at(row, column):
	var tile_number = _map[row][column].tile_number
	if tile_number == 0:
		return
	var tile = tile_scenes[tile_number - 1].instance()
	tile.position = Vector2(column * 8, row * 8)
	_map[row][column].tile_instance = tile
	add_child(tile)


