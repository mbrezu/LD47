extends Node2D

var _letter

func set_letter(letter):
	_letter = letter

func _ready():
	if _letter[0] >= "A" and _letter[0] <= "Z":
		$Sprite.region_rect = Rect2(
			144 + (_letter.ord_at(0) - "A".ord_at(0)) * 8, 64, 8, 8)
	elif _letter[0] >= "0" and _letter[0] <= "9":
		$Sprite.region_rect = Rect2(
			144 + (_letter.ord_at(0) - "0".ord_at(0)) * 8, 72, 8, 8)
	elif _letter[0] == '.':
		$Sprite.region_rect = Rect2(224, 72, 8, 8)
	elif _letter[0] == ",":
		$Sprite.region_rect = Rect2(232, 72, 8, 8)
	elif _letter[0] == "\"":
		$Sprite.region_rect = Rect2(240, 72, 8, 8)
	elif _letter[0] == "'":
		$Sprite.region_rect = Rect2(248, 72, 8, 8)
	elif _letter[0] == "!":
		$Sprite.region_rect = Rect2(256, 72, 8, 8)
	elif _letter[0] == "-":
		$Sprite.region_rect = Rect2(224, 80, 8, 8)
	elif _letter[0] == "_":
		$Sprite.region_rect = Rect2(232, 80, 8, 8)
	elif _letter[0] == ":":
		$Sprite.region_rect = Rect2(240, 80, 8, 8)
	elif _letter[0] == " ":
		$Sprite.region_rect = Rect2(0, 0, 0, 0)
	else:
		$Sprite.region_rect = Rect2(264, 72, 8, 8)
