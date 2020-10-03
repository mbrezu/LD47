extends Node2D


var panel_scene = preload("res://scenes/panel.tscn")
var game_scene = preload("res://scenes/game.tscn")

var _state = Consts.GameState.NOTHING
var _next_state = []


func _ready():
	_next_state.push_back(Consts.GameState.MENU)


func _process(_delta):
	if not _next_state.empty():
		_handle_state_transition(_state, _next_state.pop_front())
	if Input.is_action_just_pressed("ui_select"):
		_handle_space_pressed()


func _handle_space_pressed():
	match _state:
		Consts.GameState.MENU:
			_next_state.push_back(Consts.GameState.IN_GAME)
			Input.action_release("ui_select")


func _handle_state_transition(_current, _desired):
	match [_current, _desired]:
		[Consts.GameState.NOTHING, Consts.GameState.MENU]:
			_show_menu()
			_state = _desired
			return
		[Consts.GameState.MENU, Consts.GameState.IN_GAME]:
			Utils.delete_children($menu_layer)
			_new_game()
			_state = _desired
			return 
		[_, Consts.GameState.NOTHING]:
			Utils.delete_children($menu_layer)
			_state = _desired
			return
	_next_state.push_back(Consts.GameState.NOTHING)
	_next_state.push_back(_desired)


func _new_game():
	Utils.delete_children($menu_layer)
	Utils.delete_children($game_layer)
	var game = game_scene.instance()
	$game_layer.add_child(game)


func _show_menu():
	Utils.delete_children($menu_layer)
	var panel = panel_scene.instance()
	panel.configure(14, 28)
	$menu_layer.add_child(panel)
	panel.text_at(2, 2, "LOOP SMTH SMTH")
	panel.text_at(4, 2, "PRESS 'SPACE\" TO PLAY!")
	panel.text_at(6, 2, "CONTROLS: ALSO 'SPACE\"")
	panel.text_at(8, 2, "GAME BY MBREZU, LEONEL")
	panel.text_at(9, 2, "AND CRISTI_ABY")
	panel.text_at(11, 2, "MADE FOR LUDUM DARE 47")
