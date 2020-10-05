extends ColorRect

var _min
var _max
var _value
var _desired_value


var started
var intensity


func _ready():
	_min = 0.15
	_max = 0.75
	_value = _max
	_desired_value = _min
	started = false


func reset():
	_value = _max
	_desired_value = _min


func _process(delta):
	if started:
		var speed = clamp(5 * intensity, 10, 20)
		_value = lerp(_value, _desired_value, delta * speed)
		if abs(_value - _desired_value) < 0.01:
			if _desired_value == _min:
				_desired_value = _max
			else:
				_desired_value = _min
		print(_value)
		get_material().set_shader_param("distance_threshold", _value)
		get_material().set_shader_param("intensity", intensity)
	else:
		get_material().set_shader_param("distance_threshold", 100)

