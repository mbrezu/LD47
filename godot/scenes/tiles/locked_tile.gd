extends "res://scripts/tile.gd"

var _disappearing = false


func set_tile(tile):
	$tile_container.add_child(tile)


func _process(delta):
	if _disappearing:
		var angle = randf() * 2 * PI
		var radius = 8
		var desired_position = Vector2(radius * cos(angle), -radius * sin(angle))
		$lock.position = Utils.v2_lerp($lock.position, desired_position, delta * 2)


func unlock():
	_disappearing = true
	$unlock_timer.wait_time = 0.5 + randf() * 1
	$unlock_timer.start()


func _on_unlock_timer_timeout():
	_disappearing = false
	$lock.queue_free()
