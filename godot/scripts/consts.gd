extends Node

const TILES_COUNT = 7
const MAP_ROWS = 16
const MAP_COLUMNS = 24
const START_SQUARE_ROW = 8
const START_SQUARE_COLUMN = 12
const LOOKAHEAD = 5

const REZ_X = 256
const REZ_Y = 150

enum GameState { NOTHING, MENU, IN_GAME, GAME_OVER }
