extends Node2D

signal player_moved(old_row, old_column, new_row, new_column)
signal player_stopped

var Cursor = load("res://scripts/cursor.gd")

var _map
var _target_position = null
var player_speed = 4
var _cursor


func configure(map):
	_map = map


func set_map_position(row, column):
	_cursor = Cursor.new(row, column, 0)
	position = Vector2(_cursor.column * 8, _cursor.row * 8)
	_target_position = position


func _update_position():
	_target_position = Vector2(_cursor.column * 8, _cursor.row * 8)


func _process(delta):
	if _target_position != null:
		position = Utils.v2_lerp(position, _target_position, delta * player_speed)
		if position.distance_to(_target_position) < 1:
			position = _target_position
			emit_signal("player_stopped")


func get_cursor():
	return _cursor.clone()


func advance():
	var old_cursor = _cursor.clone()
	if _advance_cursor(_cursor):
		emit_signal("player_moved", old_cursor.row, old_cursor.column, _cursor.row, _cursor.column)
	#		print("  new pos is ", _row, " ", _column)
		_update_position()


func _advance_cursor(cursor):
	if _try_move(cursor):
		_rotate(cursor)
		return true
	else:
		_rotate(cursor)
		return _try_move(cursor)


func get_arrows():
	var arrow_cursor = _cursor.clone()
	_advance_cursor(arrow_cursor)
	var result = []
	while true:
		var is_not_free = _map.is_free(arrow_cursor.row, arrow_cursor.column)
		var is_player = arrow_cursor.row == _cursor.row and arrow_cursor.column == _cursor.column
		var already_arrow = arrow_cursor.in_array(result)
		if is_not_free or is_player or already_arrow:
			break
		if result.size() >= 10:
			break
		result.append(arrow_cursor.clone())
		_advance_cursor(arrow_cursor)
	return result


func _try_move(cursor):
	if _is_free(cursor.clone().move()):
		cursor.move()
		return true
	return false


func _rotate(cursor):
	if _is_free(cursor.clone().turn_left().move()):
		cursor.turn_left()
	elif _is_free(cursor.clone().move()):
		pass # _direction unchanged
	elif _is_free(cursor.clone().turn_right().move()):
		cursor.turn_right()
	elif _is_free(cursor.clone().turn_back().move()):
		cursor.turn_back()
	else:
		pass # direction unchanged
#	print("  next direction ", directions[direction])


func _is_free(cursor):
	return _map.is_free(cursor.row, cursor.column)

