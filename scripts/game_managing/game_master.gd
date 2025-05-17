class_name GameMaster
extends Node2D

const controllers_binding_packed_scene: PackedScene = preload("res://scenes/settings/controllers_binding_settings.tscn")
var controllers_binding_scene: ControllersBinding
const end_scene_packed_scene: PackedScene = preload("res://scenes/finish_screen.tscn")

@export var map_data: MapData = load("res://maps/output.tres")

@export var players: Array[Player]
var alive_players: int
var players_scores: Array[int]
var winners: Array[Player] = []

var round_count: int
var current_round: int
var round_duration: int

var players_devices_ids = [-2, 0, 1, 2]

var running: bool = false

func load_game(players_list: Array[Player]):
	# Load the players
	#players = players_list
	controllers_binding_scene = controllers_binding_packed_scene.instantiate()
	await controllers_binding_scene.players_ready
	controllers_binding_scene.queue_free()
	players = Global.players
	print("Players: ", players)
	alive_players = len(players)
	players_scores = []
	%SplitScreen.players = players
	# Add them to the scene tree
	for player_index in len(players):
		var player = players[player_index]
		add_child(player)
		players_scores.append(0)
		player.frozen = true
		#player.device_id = players_devices_ids[player_index]
		#player.device_id = player_index - 1
	#players[0].device_id = -2

func load_map(map: MapData):
	# Load the map
	$TileMaps/WaterBackground.tile_map_data = map.water_background
	$TileMaps/VoidBackGround.tile_map_data = map.void_background
	$TileMaps/WaterSideLayer.tile_map_data = map.water_side_layer
	$TileMaps/LowerGroundLayer.tile_map_data = map.lower_ground_layer
	$TileMaps/WallLayer.tile_map_data = map.wall_layer
	$TileMaps/ObjectLayer1.tile_map_data = map.object_layer_1
	$TileMaps/ObjectLayer2.tile_map_data = map.object_layer_2
	$TileMaps/ObjectLayer3.tile_map_data = map.object_layer_3
	$TileMaps/CollisionLayer.tile_map_data = map.collision_layer
	# Load the players
	if len(players) <= len(map.players_spawns):
		for player_index in len(players):
			var player = players[player_index]
			player.position = map.players_spawns[player_index]

func start_round():
	print(current_round)
	# Séquence début de round incroyable que Hadrien va gentillement faire
	# Connection des signaux
	SignalBus.player_died.connect(handle_killed_player)
	# Start timer
	%GameFinishTimer.connect("timeout", end_round)
	%GameFinishTimer.start(1000)#round_duration)
	# Unfreeze players
	set_players_frozen_state(false)

func end_round():
	print("finish")
	# Stop timmer
	%GameFinishTimer.stop()
	# Freeze players
	set_players_frozen_state(true)
	# Disconnect signals
	SignalBus.player_died.disconnect(handle_killed_player)
	# Update scores
	var winners_ids := find_winners()
	winners = []
	for winner_id in winners_ids:
		players_scores[winner_id] += 1
		var winner = Global.players[winner_id]
		winners.append(winner)
	%GameDisplayEndScreenDelay.connect("timeout", display_end_screen_and_stuff)
	%GameDisplayEndScreenDelay.start(3)

func display_end_screen_and_stuff():
	%GameDisplayEndScreenDelay.stop()
	%GameDisplayEndScreenDelay.disconnect("timeout", display_end_screen_and_stuff)
	var end_scene = end_scene_packed_scene.instantiate()
	%SplitScreen.add_child(end_scene)
	end_scene.display_winners(winners)
	end_scene.position = Vector2.ZERO
	await get_tree().create_timer(5).timeout
	end_scene.queue_free()
	for player in players:
		player.linked_inventory.display_ui(player.inventory_storage)
	# Check if a new round have to start
	if current_round < round_count:
		current_round += 1
		#start_round()
	

func start_game(rounds: int, rounds_duration: int):
	#for controller in Input.get_connected_joypads():
		#Input.start_joy_vibration(controller, 1, 1, 5)
	%SplitScreen.add_child(controllers_binding_scene)
	load_map(map_data)
	round_duration = rounds_duration
	round_count = rounds
	current_round = 1
	start_round()

func find_winners() -> Array[int]:
	var current_winners_ids: Array[int] = []
	var highest_health: int = 0
	for player_index in len(players):
		var player_health: int = players[player_index].player_stats.stat_effective_health
		if player_health > highest_health:
			highest_health = player_health
			current_winners_ids = [player_index]
		elif player_health == highest_health:
			current_winners_ids.append(player_index)
	return current_winners_ids

func set_players_frozen_state(frozen_state: bool):
	for player in players:
		player.frozen = frozen_state

func handle_killed_player(player:Player):
	alive_players -= 1
	if alive_players == 1:
		end_round()

func save_map_data() -> MapData:
	var saved_map_data := MapData.new()
	saved_map_data.water_background = $TileMaps/WaterBackground.tile_map_data
	saved_map_data.void_background = $TileMaps/VoidBackGround.tile_map_data
	saved_map_data.water_side_layer = $TileMaps/WaterSideLayer.tile_map_data
	saved_map_data.lower_ground_layer = $TileMaps/LowerGroundLayer.tile_map_data
	saved_map_data.wall_layer = $TileMaps/WallLayer.tile_map_data
	saved_map_data.object_layer_1 = $TileMaps/ObjectLayer1.tile_map_data
	saved_map_data.object_layer_2 = $TileMaps/ObjectLayer2.tile_map_data
	saved_map_data.object_layer_3 = $TileMaps/ObjectLayer3.tile_map_data
	saved_map_data.collision_layer = $TileMaps/CollisionLayer.tile_map_data
	return saved_map_data

#func _input(event: InputEvent) -> void:
	#if event.as_text() == "Left Mouse Button":
		#ResourceSaver.save(save_map_data(), "res://maps/output.tres")
#
#func _ready() -> void:
	#if delay_before_start >= 0:
		#%GameStartDelay.connect("timeout", start_game)
		#%GameStartDelay.start(delay_before_start)

#func open_close_inventory(_player:Player):
	#var player_id = Global.players.find(_player)
	#if _player.is_inventory_open:
		#_player.is_inventory_open = false
		#_player.inventory_storage = get("inventory_UI_"+str(player_id)).hide_ui()
	#else :
		#_player.is_inventory_open = true
		#get("inventory_UI_"+str(player_id)).display_ui(_player.inventory_storage)
		

#func actualise_health_bar(_player: Player):
	#var player_id = Global.players.find(_player)
	#get("health_bar_"+str(player_id)).max_health = _player.player_stats.stat_max_health
	#get("health_bar_"+str(player_id)).health = _player.player_stats.stat_effective_health
