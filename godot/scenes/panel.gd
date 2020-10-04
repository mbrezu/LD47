extends Node2D

var panel_scenes = [
	preload("res://scenes/panel/panel_1.tscn"),
	preload("res://scenes/panel/panel_2.tscn"),
	preload("res://scenes/panel/panel_3.tscn"),
	preload("res://scenes/panel/panel_4.tscn"),
	preload("res://scenes/panel/panel_5.tscn"),
	preload("res://scenes/panel/panel_6.tscn"),
	preload("res://scenes/panel/panel_7.tscn"),
	preload("res://scenes/panel/panel_8.tscn"),
	preload("res://scenes/panel/panel_9.tscn")
]

var letter_scene = preload("res://scenes/letter.tscn")

var _rows
var _columns
var _display_queue = []

func configure(rows, columns):
	_rows = rows
	_columns = columns
	position = Vector2(
		(Consts.REZ_X - 8 * _columns) / 2,
		(Consts.REZ_Y - 8 * _rows) / 2)

func text_at(row, column, text):
	for i in range(text.length()):
		var ch = text[i]
		var letter = letter_scene.instance()
		letter.set_letter(ch)
		letter.position = Vector2((column + i) * 8, row * 8)
		_display_queue.push_back(letter)


func color_text_at(row, column, text, color):
	for i in range(text.length()):
		var ch = text[i]
		var letter = letter_scene.instance()
		letter.set_letter(ch)
		letter.position = Vector2((column + i) * 8, row * 8)
		_display_queue.push_back(letter)
		letter.modulate = color


func _ready():
	_build_background()


func _build_background():
	for i in range(1, _rows - 1):
		_put_tile(3, i, 0)
		_put_tile(5, i, _columns - 1)
	for i in range(1, _columns - 1):
		_put_tile(1, 0, i)
		_put_tile(7, _rows - 1, i)
	for i in range(1, _rows - 1):
		for j in range(1, _columns - 1):
			_put_tile(4, i, j)
	_put_tile(0, 0, 0)
	_put_tile(2, 0, _columns - 1)
	_put_tile(6, _rows - 1, 0)
	_put_tile(8, _rows - 1, _columns - 1)

func _put_tile(tile_number, row, column):
	var tile = panel_scenes[tile_number].instance()
	tile.position = Vector2(column * 8, row * 8)
	add_child(tile)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	if not _display_queue.empty():
		add_child(_display_queue.pop_front())

