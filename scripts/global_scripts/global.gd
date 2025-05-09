extends Node

enum PLAYER_COUNT {
	ONE,
	TWO,
	THREE,
	FOUR,
}

const PLAYER = preload("res://scenes/player.tscn")

var players: Array[Player] = [PLAYER.instantiate()]

func _ready() -> void:
	
	#var new_player = Player.new()
	#new_player.device_id = -2
	#players.append(new_player)
	#new_player = Player.new()
	#new_player.device_id = 0
	#players.append(new_player)
	#new_player = Player.new()
	#new_player.device_id = 1
	#players.append(new_player)

	@warning_ignore("int_as_enum_without_cast")
	var player_count: PLAYER_COUNT = len(players)-1
	
	match  player_count:
		PLAYER_COUNT.ONE:
			pass
		PLAYER_COUNT.TWO:
			pass
		PLAYER_COUNT.THREE:
			pass
