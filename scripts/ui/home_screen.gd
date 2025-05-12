extends Control

func launch_game() -> void:
	var game_scene = GameManager.load_game(1000)
	get_tree().root.add_child(game_scene)
	queue_free()

func _init() -> void:
	#%PlayButton.connect("pressed", launch_game)
	pass
