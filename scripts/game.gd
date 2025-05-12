extends Node2D


@onready var inventory_UI_0: InventoryUI = %Inventory_0
@onready var inventory_UI_1: InventoryUI = %Inventory_1
@onready var health_bar_0: HealthBar = %HealthBar0
@onready var health_bar_1: HealthBar = %HealthBar1

var player: Player

func _ready() -> void:
	SignalBus.health_change.connect(actualise_health_bar)
	
	
	
	#for _player in Global.players:
		#player = _player
		#add_child(player)


	
#
#func open_close_inventory(_player:Player):
	#var player_id = Global.players.find(_player)
	#if _player.is_inventory_open:
		#_player.is_inventory_open = false
		#_player.inventory_storage = get("inventory_UI_"+str(player_id)).hide_ui()
	#else :
		#_player.is_inventory_open = true
		#get("inventory_UI_"+str(player_id)).display_ui(_player.inventory_storage)
		

func actualise_health_bar(_player: Player):
	var player_id = Global.players.find(_player)
	#get("health_bar_"+str(player_id)).max_health = _player.player_stats.stat_max_health
	#get("health_bar_"+str(player_id)).health = _player.player_stats.stat_effective_health
