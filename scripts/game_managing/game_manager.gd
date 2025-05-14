extends Node

var game_scene: GameMaster

func load_game(round_duration_s: int) -> Node2D:
	var game_scene_packed_scene: PackedScene = load("res://scenes/game.tscn")
	game_scene = game_scene_packed_scene.instantiate()
	var new_player_packed_scene: PackedScene = load("res://scenes/player.tscn")
	for i in range(4):
		var new_player = new_player_packed_scene.instantiate()
		Global.players.append(new_player)
	game_scene.load_game(Global.players)
	return game_scene

func start(round_duration_s: int):
	game_scene.start_game(1, round_duration_s)
	pass
