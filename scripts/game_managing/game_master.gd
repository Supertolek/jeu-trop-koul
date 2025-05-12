class_name GameMaster
extends Node2D


#@onready var inventory_UI_0: InventoryUI = %Inventory_0
#@onready var inventory_UI_1: InventoryUI = %Inventory_1
#@onready var health_bar_0: HealthBar = %HealthBar0
#@onready var health_bar_1: HealthBar = %HealthBar1

@export var map_data: MapData = load("res://maps/output.tres")

@export var players: Array[Player]
var running: bool = false

var delay_before_start: int = -1

func load_game(players_list: Array[Player], round_duration_s: float):
	%GameFinishTimer.wait_time = round_duration_s
	# Load the map
	$TileMaps/WaterBackground.tile_map_data = map_data.water_background
	$TileMaps/VoidBackGround.tile_map_data = map_data.void_background
	$TileMaps/WaterSideLayer.tile_map_data = map_data.water_side_layer
	$TileMaps/LowerGroundLayer.tile_map_data = map_data.lower_ground_layer
	$TileMaps/WallLayer.tile_map_data = map_data.wall_layer
	$TileMaps/ObjectLayer1.tile_map_data = map_data.object_layer_1
	$TileMaps/ObjectLayer2.tile_map_data = map_data.object_layer_2
	$TileMaps/ObjectLayer3.tile_map_data = map_data.object_layer_3
	$TileMaps/CollisionLayer.tile_map_data = map_data.collision_layer
	# Load the players
	players = players_list
	if len(players) <= len(map_data.players_spawns):
		for player_index in len(players):
			var player = players[player_index]
			add_child(player)
			player.position = map_data.players_spawns[player_index]

func start_game():
	%GameFinishTimer.start()

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

func _input(event: InputEvent) -> void:
	if event.as_text() == "Left Mouse Button":
		ResourceSaver.save(save_map_data(), "res://maps/output.tres")

func _ready() -> void:
	if delay_before_start >= 0:
		%GameStartDelay.connect("timeout", start_game)
		%GameStartDelay.start(delay_before_start)

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
