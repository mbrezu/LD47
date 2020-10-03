extends Node2D

var _player
var _add_tile = false


func _ready():
	$player.configure($map)
	$player.set_map_position(8, 13)
	$player.connect("player_moved", self, "_on_player_moved")


func _process(_delta):
	if Input.is_action_just_pressed("ui_select"):
#		player.advance()
		Input.action_release("ui_select")
		_add_tile = true


func _on_player_moved(old_row, old_column, row, column):
	print("player moved ", [old_row, old_column, row, column])
	if _add_tile:
		print("adding tile")
		_add_tile = false
		$map.add_random_tile(old_row, old_column)


func _on_advance_timer_timeout():
	$player.advance()
