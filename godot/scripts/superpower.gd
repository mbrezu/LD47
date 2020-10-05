extends Node2D

var row
var column
var type = "UNKNOWN"
var _collected = false

func collect():
	_collected = true


func _process(delta):
	if _collected:
		scale *= 1 + 1 * delta
		modulate.a *= 0.98
	if modulate.a < 0.5:
		queue_free()
