var row
var column
var direction

func _init(p_row, p_column, p_direction):
	row = p_row
	column = p_column
	direction = p_direction


func move():
	row += Consts.DIRECTIONS[direction][0]
	column += Consts.DIRECTIONS[direction][1]
	return self


func clone():
	return get_script().new(row, column, direction)


func turn_left():
	direction += 1
	if direction == 4:
		direction = 0
	return self


func turn_right():
	direction -= 1
	if direction < 0:
		direction = 3
	return self


func turn_back():
	direction += 2
	direction %= 4
	return self


func in_array(cursors):
	for c in cursors:
		if row == c.row and column == c.column:
			return true
	return false


func str():
	return str(["Cursor", row, column, direction])
