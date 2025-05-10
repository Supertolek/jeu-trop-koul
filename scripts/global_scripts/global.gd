extends Node

enum PLAYER_COUNT {
	ONE,
	TWO,
	THREE,
	FOUR,
}

const PLAYER = preload("res://scenes/player.tscn")

var players: Array[Player] = []

func _ready() -> void:
	
	var player_1 = PLAYER.instantiate()
	player_1.device_id = -2
	player_1.global_position = Vector2(500,400)
	players.append(player_1)
	var player_2 = PLAYER.instantiate()
	player_2.device_id = 0
	player_2.global_position = Vector2(200,400)
	players.append(player_2)
	player_1.enemy = player_2
	player_2.enemy = player_1
	#var player_3 = PLAYER.instantiate()
	#player_3.device_id = 1
	#player_3.global_position = Vector2(500,500)
	#players.append(player_3)

	@warning_ignore("int_as_enum_without_cast")
	var player_count: PLAYER_COUNT = len(players)-1
	
	match  player_count:
		PLAYER_COUNT.ONE:
			pass
		PLAYER_COUNT.TWO:
			pass
		PLAYER_COUNT.THREE:
			pass
