extends Control

func launch_game() -> void:
	var game_scene = await GameManager.load_game(10)
	GameManager.start(10)
	queue_free()
