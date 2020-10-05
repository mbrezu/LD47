extends Node2D

signal game_over

var Cursor = preload("res://scripts/cursor.gd")

var arrow_display_scene = preload("res://scenes/arrow_display.tscn")
var superpower_bomb_scene = preload("res://scenes/superpowers/bomb.tscn")
var superpower_watch_scene = preload("res://scenes/superpowers/watch.tscn")
var superpower_multiplier_scene = preload("res://scenes/superpowers/multiplier.tscn")

var _player
var _game_over = false
var _score = 0
var _old_player_pos = []
var _shake = false
var _shake_amplitude
var _superpowers = []
var _score_multiplier = 1


func _ready():
	$player.configure($map)
	$player.set_map_position(Consts.START_SQUARE_ROW, Consts.START_SQUARE_COLUMN + 1)
	var _dummy = $player.connect("player_moved", self, "_on_player_moved")
	_dummy = $player.connect("player_stopped", self, "_on_player_stopped")
	_dummy = $map.connect("segment_deleted", self, "_on_segment_deleted")
	update_score_label()
	$next_tile_marker.add_child($map.make_tile_instance($next_items.get_next_tile_number()))
	$game_over_timer.wait_time = Consts.PLACE_TILE_TIMEOUT
	$game_over_timer.start()
	_init_superpowers()


func _init_superpowers():
	for _x in range(Consts.SUPERPOWERS_BOMBS_COUNT):
		_add_superpower(superpower_bomb_scene)
	for _x in range(Consts.SUPERPOWERS_WATCHES_COUNT):
		_add_superpower(superpower_watch_scene)
	for _x in range(Consts.SUPERPOWERS_MULTIPLIERS_COUNT):
		_add_superpower(superpower_multiplier_scene)


func _add_superpower(superpower_scene):
	var row = 3 + randi() % (Consts.MAP_ROWS - 6)
	var column = 3 + randi() % (Consts.MAP_COLUMNS - 6)
	var superpower = superpower_scene.instance()
	superpower.position = Vector2(column * 8, row * 8)
	superpower.row = row
	superpower.column = column
	$superpowers.add_child(superpower)
	_superpowers.append(superpower)


func _process(delta):
	if _shake:
		_shake_game(delta)
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
	_handle_blood_vignette(rounded_time)
	if _old_player_pos.size() > 0:
		$next_tile_marker.visible = $map.is_free(
			_old_player_pos[0].row, _old_player_pos[0].column)


func _handle_blood_vignette(rounded_time):
	if _game_over:
		$blood_vignette.started = false
	else:
		if rounded_time < 3 and not $blood_vignette.started:
			$blood_vignette.reset()
		$blood_vignette.started = rounded_time < 3
		$blood_vignette.intensity = 1 + pow(3 - rounded_time, 1.5)


func _shake_game(delta):
	var angle = randf() * 2 * PI
	var radius = _shake_amplitude * (1 + randf() * 0.5)
	var desired_position = Vector2(radius * cos(angle), -radius * sin(angle))
	position = Utils.v2_lerp(position, desired_position, delta * 2)


func _add_tile():
	if _old_player_pos.empty():
		return
	if not $map.is_free(_old_player_pos[0].row, _old_player_pos[0].column):
		return
	$game_over_timer.start()
	var tile_number = $next_items.get_next_tile_number()
	var is_locked = $next_items.get_next_is_locked()
	$map.add_tile(_old_player_pos[0].row, _old_player_pos[0].column, tile_number, is_locked)
	$sounds.play_tile_placed(tile_number)
	$next_items.advance()
	Utils.delete_children($next_tile_marker)
	var next_tile_number = $next_items.get_next_tile_number()
	$next_tile_marker.add_child($map.make_tile_instance(next_tile_number))


func _on_player_moved(old_row, old_column, row, column):
#	print("player moved ", [old_row, old_column, row, column])
	_old_player_pos = [Cursor.new(old_row, old_column, 0)]
	$next_tile_marker.position = Vector2(old_column * 8, old_row * 8)
	var superpower = _get_superpower(row, column)
	if superpower != null:
		superpower.collect()
		match superpower.type:
			"BOMB": _activate_bomb()
			"WATCH": _activate_watch()
			"MULTIPLIER": _score_multiplier *= 2


func _get_superpower(row, column):
	for i in range(_superpowers.size()):
		var superpower = _superpowers[i]
		if superpower.row == row and superpower.column == column:
			_superpowers.remove(i)
			return superpower
	return null


func _activate_bomb():
	$map.activate_bomb()


func _activate_watch():
	$player.player_speed = Consts.PLAYER_SPEED


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


func _on_segment_deleted(size, tile_number):
	_score += size * size * _score_multiplier
	$player.player_speed += 0.02 * Consts.PLAYER_SPEED
	$next_items.increase_tetromino_count()
	for _i in range(size):
		$sounds.play_tile_destroyed(tile_number)
	update_score_label()
	_shake = true
	_shake_amplitude = pow(size, 1.5) * 4
	$shake_stop_timer.wait_time = 0.5 + randf() * 0.1 * pow(size, 1.5)
	$shake_stop_timer.start()


func update_score_label():
	$score.set_label("SCORE:" + str(_score))


func _on_game_over_timer_timeout():
	if not _game_over:
		_game_over = true
		$player.start_death_animation()
		$sounds.play_player_died()
		_shake = true
		_shake_amplitude = 80
		$shake_stop_timer.wait_time = 3
		$shake_stop_timer.start()
		yield(get_tree().create_timer(3.0), "timeout")
		emit_signal("game_over")


func _on_shake_stop_timer_timeout():
	position = Vector2(0, 0)
	_shake = false

