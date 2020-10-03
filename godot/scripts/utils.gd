extends Node


func delete_children(node):
	for n in node.get_children():
		n.queue_free()

func v2_lerp(v1, v2, t):
	return Vector2(
		v1.x + (v2.x - v1.x) * t,
		v1.y + (v2.y - v1.y) * t)
