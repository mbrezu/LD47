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

var player_scene = preload("res://scenes/player.tscn")

# map, there's space for 16 rows by 24 columns
var _map = []
var _player
var _add_tile = false


func _ready():
	initialize_map()
#	map_dump()
	render_map()
	_player = player_scene.instance()
	$player_layer.add_child(_player)
	_player.configure(_map)
	_player.set_map_position(8, 13)
	_player.connect("player_moved", self, "_on_player_moved")


func _process(_delta):
	if Input.is_action_just_pressed("ui_select"):
#		player.advance()
		Input.action_release("ui_select")
		_add_tile = true


func _on_player_moved(old_row, old_column, row, column):
	print("player moved ", [old_row, old_column, row, column])
	if _add_tile:
		_add_tile = false
		print("adding tile")
		var tile_number = randi() % 7 + 1
		_map[old_row][old_column].tile_number = tile_number
		add_tile_at(tile_number, old_row, old_column)

func initialize_map():
	_map = []
	for _row_index in range(0, 16):
		var row = []
		for _col_index in range(0, 24):
			row.append(MapCell.new(0))
		_map.append(row)
	_map[8][12].tile_number = 1


func map_dump():
	for row in _map:
		var row_str = ""
		for cell in row:
			row_str += cell.str() + " "
		print(row_str)


func render_map():
	for row_index in range(0, _map.size()):
		var row = _map[row_index]
		for column_index in range(0, row.size()):
			var tile_number = row[column_index].tile_number
			if tile_number > 0:
				add_tile_at(tile_number, row_index, column_index)


func add_tile_at(tile_number, row, column):
	var tile = tile_scenes[tile_number - 1].instance()
	tile.position = Vector2(column * 8, row * 8)
	_map[row][column].tile_instance = tile
	$tiles.add_child(tile)


func _on_advance_timer_timeout():
	_player.advance()
