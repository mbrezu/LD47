extends Node2D

signal game_over

var Cursor = preload("res://scripts/cursor.gd")

var arrow_display_scene = preload("res://scenes/arrow_display.tscn")

var _player
var _game_over = false
var _score = 0
var _old_player_pos = []


func _ready():
	$player.configure($map)
	$player.set_map_position(Consts.START_SQUARE_ROW, Consts.START_SQUARE_COLUMN + 1)
	var _dummy = $player.connect("player_moved", self, "_on_player_moved")
	_dummy = $player.connect("player_stopped", self, "_on_player_stopped")
	_dummy = $map.connect("segment_deleted", self, "_on_segment_deleted")
	update_score_label()
	$next_tile_marker.add_child($map.make_tile_instance($next_items.get_next_tile_number()))


func _process(_delta):
	if Input.is_action_just_pressed("ui_select"):
#		player.advance()
		if not _game_over:
			Input.action_release("ui_select")
			_add_tile()
	var rounded_time = round($game_over_timer.time_left * 10) / 10
	var color = Color(0.2, 1, 0.2, 255)
	if rounded_time < 3:
		color = Color(1, 0.2, 0.2, 255)
	elif rounded_time < 6:
		color = Color(0.8, 0.8, 0.2, 255)
	$time.set_color(color)
	$time.set_label("TIME:" + str(rounded_time))
	if _old_player_pos.size() > 0:
		$next_tile_marker.visible = $map.is_free(
			_old_player_pos[0].row, _old_player_pos[0].column)


func _add_tile():
	if _old_player_pos.empty():
		return
	if not $map.is_free(_old_player_pos[0].row, _old_player_pos[0].column):
		return
	$game_over_timer.start()
	$map.add_tile(_old_player_pos[0].row, _old_player_pos[0].column, $next_items.get_next_tile_number())
	$next_items.advance()
	Utils.delete_children($next_tile_marker)
	$next_tile_marker.add_child($map.make_tile_instance($next_items.get_next_tile_number()))


func _on_player_moved(old_row, old_column, _row, _column):
#	print("player moved ", [old_row, old_column, row, column])
	_old_player_pos = [Cursor.new(old_row, old_column, 0)]
	$next_tile_marker.position = Vector2(old_column * 8, old_row * 8)


func _on_player_stopped():
	$player.advance()
	var arrows = $player.get_arrows()
	Utils.delete_children($arrows)
	var opacity = 0.5
	for arrow in arrows:
		if not arrow.in_array(_old_player_pos):
			var display = arrow_display_scene.instance()
			display.configure(arrow, opacity)
			opacity *= 0.9
			$arrows.add_child(display)
	
	# print("*** arrows")
	# for arrow in arrows:
	# 	print("  " + arrow.str())


func _on_player_died():
	_game_over = true
	emit_signal("game_over")


func _on_segment_deleted(size, _tile_number):
	_score += size * size
	$player.player_speed *= 1.01
	$next_items.increase_tetromino_count()
	update_score_label()


func update_score_label():
	$score.set_label("SCORE:" + str(_score))


func _on_game_over_timer_timeout():
	if not _game_over:
		_game_over = true
		emit_signal("game_over")
