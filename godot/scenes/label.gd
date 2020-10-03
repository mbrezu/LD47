extends Node2D

var letter_scene = preload("res://scenes/letter.tscn")

var _label = ""
var _is_ready = false

func set_label(label):
	_label = label
	if _is_ready:
		_render_letters()


func _ready():
	_is_ready = true
	_render_letters()


func _render_letters():
	Utils.delete_children(self)
	for i in range(_label.length()):
		var letter = letter_scene.instance()
		letter.set_letter(_label[i])
		letter.position = Vector2(i * 8, 0)
		add_child(letter)

