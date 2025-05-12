extends Node


func load_game(round_duration_s: int) -> Node2D:
	var game_scene_resource: PackedScene = load("res://scenes/game.tscn")
	var game_scene: GameMaster = game_scene_resource.instantiate()
	game_scene.load_game(Global.players, 1000)
	return game_scene

func start():
	pass
