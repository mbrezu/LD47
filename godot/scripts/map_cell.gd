# extends Node

var tile_number
var tile_instance
var is_locked

func _init(p_tile_number):
	tile_number = p_tile_number
	is_locked = false

func str():
	return str(tile_number)
