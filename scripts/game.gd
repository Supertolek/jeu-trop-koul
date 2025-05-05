extends Node2D


@onready var inventory_UI: InventoryUI = %Inventory

var player: Player

func _ready() -> void:
	for _player in Global.players:
		player = _player
		add_child(player)
		player.global_position = Vector2(576,320)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed('open_inventory'):
		if inventory_UI.visible:
			player.inventory_storage = inventory_UI.hide_ui()
		else:
			inventory_UI.display_ui(player.inventory_storage)
