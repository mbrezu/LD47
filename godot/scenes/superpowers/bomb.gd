extends "res://scripts/superpower.gd"


var frame_rects = [
	Rect2(240, 0, 8, 8),
	Rect2(248, 0, 8, 8),
	Rect2(256, 0, 8, 8),
	Rect2(248, 0, 8, 8),
]

var flame_positions = [
	Vector2(-2, 0),
	Vector2(2, 0),
	Vector2(-1, -1),
	Vector2(1, -1),
	Vector2(-1, 1),
	Vector2(1, 1),
]


var current_frame = 0


func _ready():
	$flame.region_rect = frame_rects[current_frame]
	type = "BOMB"


func _on_flame_timer_timeout():
	current_frame += 1
	if current_frame == frame_rects.size():
		current_frame = 0
	flame_positions.shuffle()
	$flame.position = flame_positions[0]
	$flame.region_rect = frame_rects[current_frame]
