extends Node2D

func _ready() -> void:
	for player in Global.players:
		add_child(player)
		player.global_position = Vector2(576,320)
	
	
