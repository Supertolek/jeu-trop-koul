extends Control

func launch_game() -> void:
	var game_scene = GameManager.load_game(10)
	GameManager.start(10)
	queue_free()
