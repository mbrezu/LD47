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

var _list = []


# Called when the node enters the scene tree for the first time.
func _ready():
	$label.set_label("NEXT:")
	for i in range(Consts.LOOKAHEAD):
		var item = MapCell.new(randi() % Consts.TILES_COUNT + 1)
		item.tile_instance = tile_scenes[item.tile_number - 1].instance()
		item.tile_instance.position = Vector2(40 + i * 9, 0)
		add_child(item.tile_instance)
		_list.append(item)


func get_next_tile_number():
	return _list[0].tile_number


func advance():
	_list[0].tile_instance.queue_free()
	_list.pop_front()
	var item = MapCell.new(randi() % Consts.TILES_COUNT + 1)
	item.tile_instance = tile_scenes[item.tile_number - 1].instance()
	add_child(item.tile_instance)
	_list.append(item)
	for i in range(Consts.LOOKAHEAD):
		_list[i].tile_instance.position = Vector2(40 + (i - 1) * 9, 0)
		_list[i].tile_instance.visible = i != 0

