extends Node2D


var panel_scene = preload("res://scenes/panel.tscn")
var game_scene = preload("res://scenes/game.tscn")

var _state = Consts.GameState.NOTHING
var _next_state = []
var _fresh_state = false


func _ready():
	_next_state.push_back(Consts.GameState.MENU)


func _process(_delta):
	if not _next_state.empty():
		_handle_state_transition(_state, _next_state.pop_front())
	if Input.is_action_just_pressed("ui_select") and not _fresh_state:
		_handle_space_pressed()


func _handle_space_pressed():
	match _state:
		Consts.GameState.MENU:
			_next_state.push_back(Consts.GameState.IN_GAME)
			Input.action_release("ui_select")
		Consts.GameState.GAME_OVER:
			_next_state.push_back(Consts.GameState.MENU)
			Input.action_release("ui_select")


func _handle_state_transition(_current, _desired):
	print("main: state changing from ", _current, " to ", _desired)
	if _current == _desired:
		print("main: same state, nothing to do")
		return
	match [_current, _desired]:
		[Consts.GameState.NOTHING, Consts.GameState.MENU]:
			_show_menu()
			_set_state(_desired)
			return
		[Consts.GameState.MENU, Consts.GameState.IN_GAME]:
			Utils.delete_children($menu_layer)
			_new_game()
			_set_state(_desired)
			return
		[Consts.GameState.IN_GAME, Consts.GameState.GAME_OVER]:
			_show_game_over()
			_set_state(_desired)
			return
		[Consts.GameState.GAME_OVER, Consts.GameState.MENU]:
			Utils.delete_children($game_layer)
			_show_menu()
			_set_state(_desired)
			return
		[_, Consts.GameState.NOTHING]:
			Utils.delete_children($menu_layer)
			Utils.delete_children($game_layer)
			_set_state(_desired)
			return
	print("main: can't match state")
	_next_state.push_back(Consts.GameState.NOTHING)
	_next_state.push_back(_desired)


func _set_state(desired):
	_state = desired
	_fresh_state = true
	$space_block_timer.start()


func _show_game_over():
	Utils.delete_children($menu_layer)
	var panel = panel_scene.instance()
	panel.configure(10, 29)
	$menu_layer.add_child(panel)
	var game_over_messages = [
		"GAME OVER!",
		"Shit HAPPENS.",
		"IT IS WHAT IT IS.",
		"CANNOT WIN THEM ALL.",
		"THERE IS NO PRIZE, ANYWAY.",
		"TOO MUCH 'SPACE\".", #\"
		"NOT ENOUGH 'SPACE\"." #\"
	]
	var game_over_message = game_over_messages[randi() % game_over_messages.size()]
	panel.text_at(2, 2, game_over_message)
	panel.text_at(4, 2, "PRESS 'SPACE\" FOR THE") #\"
	panel.text_at(5, 2, "MAIN MENU!")
	panel.text_at(7, 2, "- OR TAP ANYWHERE -")


func _new_game():
	randomize()
	Utils.delete_children($menu_layer)
	Utils.delete_children($game_layer)
	var game = game_scene.instance()
	$game_layer.add_child(game)
	game.connect("game_over", self, "_on_game_over")


func _on_game_over():
	print("main: _on_game_over")
	_next_state.push_back(Consts.GameState.GAME_OVER)


func _show_menu():
	Utils.delete_children($menu_layer)
	var panel = panel_scene.instance()
	panel.configure(16, 28)
	$menu_layer.add_child(panel)
	panel.text_at(2, 2, "LOOP SMTH SMTH")
	panel.text_at(4, 2, "PRESS 'SPACE\" TO PLAY!") #\"
	panel.text_at(5, 2, "- OR TAP ANYWHERE -") #\"
	panel.text_at(7, 2, "CONTROLS: ALSO 'SPACE\"") #\"
	panel.text_at(8, 2, "- OR TAP ANYWHERE -")
	panel.text_at(10, 2, "GAME BY MBREZU, LEONEL")
	panel.text_at(11, 2, "CRISTI_ABY AND MOCO")
	panel.text_at(13, 2, "MADE FOR LUDUM DARE 47")



func _on_space_block_timer_timeout():
	_fresh_state = false


func _on_tap_detection_input_event(_viewport, event, _shape_idx):
	if event.get_class() == "InputEventMouseButton" and event.pressed:
		Input.action_press("ui_select")

