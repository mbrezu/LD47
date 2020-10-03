extends Node2D

var _player
var _add_tile = false


func _ready():
	$player.configure($map)
	$player.set_map_position(Consts.START_SQUARE_ROW, Consts.START_SQUARE_COLUMN + 1)
	var _dummy = $player.connect("player_moved", self, "_on_player_moved")


func _process(_delta):
	if Input.is_action_just_pressed("ui_select"):
#		player.advance()
		Input.action_release("ui_select")
		_add_tile = true
		$player.advance()


func _on_player_moved(old_row, old_column, _row, _column):
#	print("player moved ", [old_row, old_column, row, column])
	if _add_tile:
		print("adding tile")
		_add_tile = false
		$advance_timer.wait_time = 1
		$advance_timer.start()
		$map.add_tile(old_row, old_column, $next_items.get_next_tile_number())
		$next_items.advance()


func _on_advance_timer_timeout():
	$player.advance()
	$advance_timer.wait_time -= 0.1
	if $advance_timer.wait_time < 0.25:
		$advance_timer.wait_time = 0.25
