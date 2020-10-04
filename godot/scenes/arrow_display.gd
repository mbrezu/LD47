extends Node2D

var arrow_scenes = [
	preload("res://scenes/arrows/arrow_up.tscn"),
	preload("res://scenes/arrows/arrow_left.tscn"),
	preload("res://scenes/arrows/arrow_down.tscn"),
	preload("res://scenes/arrows/arrow_right.tscn")
]

func configure(cursor, opacity):
	position = Vector2(cursor.column * 8, cursor.row * 8)
	var content = arrow_scenes[cursor.direction].instance()
	add_child(content)
	modulate = Color(1, 1, 1, opacity)
