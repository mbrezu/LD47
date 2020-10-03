extends Node2D

signal player_moved(old_row, old_column, new_row, new_column)

var _row
var _column
var _map
var _directions = [
	[-1, 0],
	[0, -1],
	[1, 0],
	[0, 1]
]
var _direction = 0


func configure(map):
	_map = map


func set_map_position(row, column):
	_row = row
	_column = column
	update_position()


func update_position():
	position = Vector2(_column * 8, _row * 8)


func advance():
#	print("*** player advance")
#	print("  direction is ", directions[direction])
	if is_free(_direction):
		var old_row = _row
		_row += _directions[_direction][0]
		var old_column = _column
		_column += _directions[_direction][1]
		emit_signal("player_moved", old_row, old_column, _row, _column)
#		print("  new pos is ", _row, " ", _column)
		update_position()
	if is_free(to_left(_direction)):
		_direction = to_left(_direction)
	elif is_free(_direction):
		pass # _direction unchanged
	elif is_free(to_right(_direction)):
		_direction = to_right(_direction)
	elif is_free(to_back(_direction)):
		_direction = to_back(_direction)
	else:
		pass # direction unchanged
#	print("  next direction ", directions[direction])


func to_left(dir):
	dir += 1
	if dir == 4:
		dir = 0
	return dir


func to_right(dir):
	dir -= 1
	if dir < 0:
		dir = 3
	return dir


func to_back(dir):
	dir += 2
	dir %= 4
	return dir


func is_free(dir):
	return _map.is_free(
		_row + _directions[dir][0], 
		_column + _directions[dir][1])

