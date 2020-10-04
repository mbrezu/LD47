extends Node2D

var _row
var _column
var _shake = false
var _center_position
var _desired_position
var _map


var particles_tile_scene = preload("res://scenes/particles_tile.tscn")


func start_destroy_animation(map, row, column):
	_map = map
	_row = row
	_column = column
	var timer = Timer.new()
	timer.wait_time = 0.5 + randf() * 1
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)
	timer.start()
	_shake = true
	_center_position = position
	var particles_tile = particles_tile_scene.instance()
	add_child(particles_tile)
	particles_tile.position = Vector2(4, 4)


func _process(delta):
	if not _shake:
		return
	var angle = randf() * 2 * PI
	var radius = randf() * 8
	_desired_position = _center_position + Vector2(radius * cos(angle), -radius * sin(angle))
	position = Utils.v2_lerp(position, _desired_position, delta * 5)


func _on_timer_timeout():
	print("timer_timeout")
	_map.clear_tile(_row, _column)
	queue_free()

