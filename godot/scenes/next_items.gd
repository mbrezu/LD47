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
var _tetromino_count = 0
var _is_locked_deck = []


# Called when the node enters the scene tree for the first time.
func _ready():
	_init_is_locked_deck()
	$label.set_label("NEXT:")
	for i in range(Consts.LOOKAHEAD):
		var item = MapCell.new(randi() % _get_tiles_count() + 1)
		item.tile_instance = tile_scenes[item.tile_number - 1].instance()
		item.tile_instance.visible = i != 0
		item.tile_instance.position = Vector2(40 + (i - 1) * 9, 0)
		add_child(item.tile_instance)
		_list.append(item)


func _init_is_locked_deck():
	_is_locked_deck = []
	for _x in range(Consts.LOCKED_REVERSE_FREQUENCY):
		_is_locked_deck.append(false)
	_is_locked_deck[0] = true
	_is_locked_deck.shuffle()


func increase_tetromino_count():
	_tetromino_count += 1


func get_next_tile_number():
	return _list[0].tile_number


func get_next_is_locked():
	return _is_locked_deck[0]


func advance():
	_list[0].tile_instance.queue_free()
	_list.pop_front()
	_is_locked_deck.pop_front()
	if _is_locked_deck.empty():
		_init_is_locked_deck()
	var item = MapCell.new(randi() % _get_tiles_count() + 1)
	item.tile_instance = tile_scenes[item.tile_number - 1].instance()
	add_child(item.tile_instance)
	_list.append(item)
	for i in range(Consts.LOOKAHEAD):
		_list[i].tile_instance.position = Vector2(40 + (i - 1) * 9, 0)
		_list[i].tile_instance.visible = i != 0


func _get_tiles_count():
	var result = 0
	for i in range(Consts.NEXT_ITEMS_COUNTS.size()):
		if _tetromino_count >= Consts.NEXT_ITEMS_COUNTS[i]:
			result = i + 1
	if result < 1:
		result = 1
	if result > 7:
		result = 7
	return result
