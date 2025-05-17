class_name ControllersBinding
extends Control

signal players_ready

const animated_player_packed_scene: PackedScene = preload("res://scenes/settings/settings_widgets/animated_player.tscn")
const controller_icon_packed_scene: PackedScene = preload("res://scenes/settings/settings_widgets/controller_icon.tscn")

@export_group("Controllers nav settings")
@export var controllers_echo_delay_msec: int = 500
@export var controllers_dead_zone: float = 0.2

var player_colors: Dictionary[String, Color] = {
	"Blue": Color8(18, 78, 137),
	"Green": Color8(58, 109, 83),
	"Black": Color8(70, 77, 107),
	"Red": Color8(125, 44, 50),
}
var player_cards: Array[ColorRect] ## 0: top left, 1: top right, 2: bottom left, 3: bottom_right
var players_linked_player_card: Dictionary[int, int] = {}

var controllers_cursor: Dictionary[int, ControllerIcon] = {}
var controllers_cursor_position: Dictionary[int, int] = {} ## controller_id:player_card_id
var controllers_last_action: Dictionary[int, int] = {}
var recognized_controllers: Array[int] = []
var controllers_xinput: Dictionary[int, int] = {}
var ready_controllers: Array[int] = []
var offset: int = 4

func place_player_card(relative_position: Vector2, relative_size: float, player: Player, corner: int = -1):
	# Create viewport object
	var player_card := ColorRect.new()
	add_child(player_card)
	player_cards.append(player_card)
	# Place player card
	var current_viewport_rect := get_window().get_viewport().get_visible_rect()
	#1152 × 640
	var desired_size := current_viewport_rect.size * relative_size
	player_card.size = desired_size
	player_card.position = current_viewport_rect.size * relative_position - player_card.size/2
	player_card.set_meta("linked_player", player.get_id())
	player_card.set_meta("position_id", corner)
	players_linked_player_card[Global.players.find(player)] = corner
	player_card.color = Color.BLACK
	player_card.name = "Opa gangnam style-" + str(corner)
	# Add the right backgrouond color to the card
	var player_card_background := ColorRect.new()
	player_card_background.color = player_colors[player.color]
	player_card_background.name = "You lost the game"
	match corner:
		0:
			player_card_background.position = Vector2(offset, offset)
			player_card_background.size = player_card.size - Vector2(offset*1.5, offset*1.5)
		1:
			player_card_background.position = Vector2(offset/2, offset)
			player_card_background.size = player_card.size - Vector2(offset*1.5, offset*1.5)
		2:
			player_card_background.position = Vector2(offset, offset/2)
			player_card_background.size = player_card.size - Vector2(offset*1.5, offset*1.5)
		3:
			player_card_background.position = Vector2(offset/2, offset/2)
			player_card_background.size = player_card.size - Vector2(offset*1.5, offset*1.5)
		_:
			player_card_background.position = Vector2(offset/2, offset/2)
			player_card_background.size = player_card.size - Vector2(offset, offset)
	player_card.add_child(player_card_background)
	# Place player sprite
	var animated_player_sprite: AnimatedSprite2D = animated_player_packed_scene.instantiate()
	animated_player_sprite.scale = Vector2(relative_size, relative_size) * 8
	animated_player_sprite.position = player_card.size/2
	animated_player_sprite.play("Idle")
	player_card.add_child(animated_player_sprite)
	# Add the cursors display
	var cursors_container: Control = Control.new()
	player_card_background.add_child(cursors_container)
	cursors_container.name = "UwU That's so banger! CURSORS!!!"

func place_player_cards():
	place_player_card(Vector2(0.25, 0.25), 0.5, Global.players[0], 0)
	place_player_card(Vector2(0.75, 0.25), 0.5, Global.players[1], 1)
	place_player_card(Vector2(0.25, 0.75), 0.5, Global.players[2], 2)
	place_player_card(Vector2(0.75, 0.75), 0.5, Global.players[3], 3)

func update_controller_cursor_position(controller_id: int, new_position: int):
	select_player(controller_id, 0)
	var new_player_card := player_cards[new_position]
	var new_player_card_cursor_container := new_player_card.get_child(0).get_child(0)
	if controllers_cursor[controller_id].get_parent():
		controllers_cursor[controller_id].reparent(new_player_card_cursor_container)
		controllers_cursor[controller_id].position.x = (controllers_cursor[controller_id].get_parent().get_child_count()-1)*68
		controllers_cursor[controller_id].position.y = 0
	else:
		new_player_card_cursor_container.add_child(controllers_cursor[controller_id])
		controllers_cursor[controller_id].position.x = (controllers_cursor[controller_id].get_parent().get_child_count()-1)*68
		controllers_cursor[controller_id].position.y = 0
	controllers_cursor_position[controller_id] = new_position

func select_player(controller_id: int, state: int = -1):
	var current_card = player_cards[controllers_cursor_position[controller_id]]
	var selected_player_id = current_card.get_meta("linked_player")
	var selected_player = Global.players[selected_player_id]
	if ((not controllers_cursor[controller_id].active) or state == 1) and state != 0:
		if selected_player.device_id != controller_id or state == -1:
			if selected_player.device_id in recognized_controllers:
				controllers_cursor[selected_player.device_id].active = false
			selected_player.device_id = controller_id
			selected_player.xinput_id = controllers_xinput[controller_id]
			controllers_cursor[controller_id].active = true
		else:
			selected_player.device_id = -3
			selected_player.xinput_id = -3
			controllers_cursor[controller_id].active = false
	else:
		selected_player.device_id = -3
		selected_player.xinput_id = -3
		controllers_cursor[controller_id].active = false

func _joy_connection_changed(device_id: int, connected: bool):
	if connected:
		print(
			"Device with id {device_id} ({brand} controller) connected.".format(
				{
					"device_id": device_id,
					"brand": Global.controllers_brand_names[Global.get_joypad_brand(device_id)]
				}))
	else:
		print("Device with id {device_id} disconnected.".format({"device_id": device_id}))

func _ready() -> void:
	Input.connect("joy_connection_changed", _joy_connection_changed)
	place_player_cards()
	for controller_id in Input.get_connected_joypads():
		#print("Controller name: ", Input.get_joy_name(controller_id))
		if len(recognized_controllers) < 4:
			var controller_info := Input.get_joy_info(controller_id)
			#print("Controller info: ", Input.get_joy_info(controller_id))
			if "vendor_id" in controller_info:
				if "xinput_index" in controller_info and controller_info["xinput_index"] != controller_id: continue
				var controller_brand := Global.get_joypad_brand(controller_id)
				if controller_brand != Global.CONTROLLERS_BRANDS.MISSING:
					recognized_controllers.append(controller_id)
					var controller_icon: ControllerIcon = controller_icon_packed_scene.instantiate()
					controller_icon.controller_brand = Global.get_joypad_brand(controller_id)
					controller_icon.name = "Hêtre, ou ne pas hêtre... euh non, l'hêtre c'est un arbre-" + str(controller_id)
					controller_icon.position = Vector2.ZERO
					controller_icon.active = true
					controllers_cursor[controller_id] = controller_icon
					controllers_last_action[controller_id] = Time.get_ticks_msec()
					controllers_cursor_position[controller_id] = 0
					controllers_xinput[controller_id] = -3
					update_controller_cursor_position(controller_id, len(recognized_controllers)-1)
					player_cards[controllers_cursor_position[controller_id]].set_meta("linked_player", controller_id)
			#elif "xinput_index" in controller_info:
				#if controller_info["xinput_index"] in recognized_controllers:
					#controllers_xinput[controller_info["xinput_index"]] = controller_id
		else:
			break

func _process(delta: float) -> void:
	for recognized_controller in recognized_controllers:
		if controllers_last_action[recognized_controller] + controllers_echo_delay_msec < Time.get_ticks_msec():
			var moved := false
			# X axis
			var controller_x_axis: float = Input.get_joy_axis(recognized_controller, JOY_AXIS_RIGHT_X)
			#if controllers_xinput[recognized_controller] >= 0:
				#controller_x_axis += Input.get_joy_axis(controllers_xinput[recognized_controller], JOY_AXIS_RIGHT_X)
			var controller_x_axis_abs: float = clamp(abs(controller_x_axis), 0, 1)
			if controller_x_axis_abs <= controllers_dead_zone: controller_x_axis_abs = 0
			# Y axis
			var controller_y_axis: float = Input.get_joy_axis(recognized_controller, JOY_AXIS_RIGHT_Y)
			#if controllers_xinput[recognized_controller] >= 0:
				#controller_y_axis += Input.get_joy_axis(controllers_xinput[recognized_controller], JOY_AXIS_RIGHT_Y)
			var controller_y_axis_abs: float = clamp(abs(controller_y_axis), 0, 1)
			if controller_y_axis_abs <= controllers_dead_zone: controller_y_axis_abs = 0
			if controller_x_axis_abs >= controller_y_axis_abs and controller_x_axis_abs != 0:
				if controllers_cursor_position[recognized_controller] % 2 == 0:
					update_controller_cursor_position(recognized_controller, controllers_cursor_position[recognized_controller] + 1)
				else:
					update_controller_cursor_position(recognized_controller, controllers_cursor_position[recognized_controller] - 1)
				moved = true
			if controller_y_axis_abs >= controller_x_axis_abs and controller_y_axis_abs != 0:
				update_controller_cursor_position(recognized_controller, (controllers_cursor_position[recognized_controller]+2) % 4)
				moved = true
			if not moved:
				continue
			#print(controllers_cursor_position[recognized_controller])
			#print(Time.get_ticks_msec() - controllers_last_action[recognized_controller])
			controllers_last_action[recognized_controller] = Time.get_ticks_msec()

func refresh_players_list():
	var new_player_list: Array[Player] = []
	var abandonned_players: Array[Player] = []
	for recognized_controller in recognized_controllers:
		if controllers_cursor[recognized_controller].active:
			new_player_list.append(
				Global.players[player_cards[controllers_cursor_position[recognized_controller]].get_meta("linked_player")]
			)
		else:
			abandonned_players.append(
				Global.players[player_cards[controllers_cursor_position[recognized_controller]].get_meta("linked_player")]
			)
	Global.players = new_player_list
	Global.spare_players = abandonned_players

func _input(event: InputEvent) -> void:
	if event.device in recognized_controllers:
		if event is InputEventJoypadMotion:
			if Global.get_joypad_brand(event.device) == Global.CONTROLLERS_BRANDS.XBOX:
				print([Input.get_joy_axis(event.device, JOY_AXIS_RIGHT_X), Input.get_joy_axis(event.device, JOY_AXIS_RIGHT_Y)])
			#if abs(Input.get_joy_axis(event.device, JOY_AXIS_RIGHT_X)) <= controllers_dead_zone and \
			   #abs(Input.get_joy_axis(event.device, JOY_AXIS_RIGHT_Y)) <= controllers_dead_zone:
				#controllers_last_action[event.device] = 0
			pass
		elif event is InputEventJoypadButton:
			if event.button_index == JOY_BUTTON_A and event.pressed:
				select_player(event.device)
			elif event.button_index == JOY_BUTTON_START and event.pressed:
				if event.device in ready_controllers:
					ready_controllers.remove_at(ready_controllers.find(event.device))
					controllers_cursor[event.device].is_ready = false
				else:
					ready_controllers.append(event.device)
					controllers_cursor[event.device].is_ready = true
					if len(ready_controllers) >= len(recognized_controllers):
						refresh_players_list()
						players_ready.emit()
