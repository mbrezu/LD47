extends Node

const TILES_COUNT = 7
const MAP_ROWS = 17
const MAP_COLUMNS = 32
const START_SQUARE_ROW = 8
const START_SQUARE_COLUMN = 16
const LOOKAHEAD = 6

const REZ_X = 256
const REZ_Y = 150

enum GameState { NOTHING, MENU, IN_GAME, GAME_OVER }

var DIRECTIONS = [
	[-1, 0],
	[0, -1],
	[1, 0],
	[0, 1]
]
