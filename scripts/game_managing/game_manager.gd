extends Node

var game_scene: GameMaster

func load_game(round_duration_s: int) -> Node2D:
	var game_scene_resource: PackedScene = load("res://scenes/game.tscn")
	game_scene = game_scene_resource.instantiate()
	game_scene.load_game(Global.players, round_duration_s)
	return game_scene

func start(round_duration_s: int):
	game_scene.start_game(1, round_duration_s)
	pass
