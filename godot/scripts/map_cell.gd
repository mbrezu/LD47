# extends Node

var tile_number
var tile_instance

func _init(p_tile_number):
	tile_number = p_tile_number

func str():
	return str(tile_number)
