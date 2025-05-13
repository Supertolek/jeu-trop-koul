extends Control

func launch_game() -> void:
	var game_scene = GameManager.load_game(10)
	get_tree().root.add_child(game_scene)
	GameManager.start(10)
	queue_free()
