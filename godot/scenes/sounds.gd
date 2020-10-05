extends Node2D

onready var place_sounds = [
	$place_sound_1,
	$place_sound_2,
	$place_sound_3,
	$place_sound_4,
	$place_sound_5,
	$place_sound_6,
	$place_sound_7,
]


onready var explosion_sounds = [
	$explosion_1,
	$explosion_2,
	$explosion_3,
	$explosion_4,
	$explosion_5,
	$explosion_6,
	$explosion_7,
]


func play_tile_placed(tile_number):
	place_sounds[tile_number - 1].play()


func play_tile_destroyed(tile_number):
	yield(get_tree().create_timer(randf() * 0.25), "timeout")
	explosion_sounds[tile_number - 1].play()


func play_player_died():
	$player_died.play()

