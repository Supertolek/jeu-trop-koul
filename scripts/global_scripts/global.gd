extends Node

enum PLAYER_COUNT {
	ONE,
	TWO,
	THREE,
	FOUR,
}

const PLAYER = preload("res://scenes/player.tscn")

var players: Array[Player] = []

enum CONTROLLERS_BRANDS {
	XBOX,
	XBOX_AS_XINPUT,
	PLAYSTATION,
	NINTENDO,
	GENERIC,
	MISSING,
}
const controllers_brand_names: Dictionary[CONTROLLERS_BRANDS, String] = {
	CONTROLLERS_BRANDS.XBOX: "xbox_wireless",
	CONTROLLERS_BRANDS.XBOX_AS_XINPUT: "xbox_xinput",
	CONTROLLERS_BRANDS.PLAYSTATION: "playstation",
	CONTROLLERS_BRANDS.NINTENDO: "nintendo",
	CONTROLLERS_BRANDS.GENERIC: "generic",
	CONTROLLERS_BRANDS.MISSING: "",
}
const vendors_ids: Dictionary[String, CONTROLLERS_BRANDS] = {
	"24068": CONTROLLERS_BRANDS.XBOX,
	"1118": CONTROLLERS_BRANDS.XBOX_AS_XINPUT,
	"19461": CONTROLLERS_BRANDS.PLAYSTATION,
}
var controllers_brand: Dictionary[int, CONTROLLERS_BRANDS] = {}

func get_joypad_brand(device_id: int) -> CONTROLLERS_BRANDS:
	if device_id in Input.get_connected_joypads():
		if "vendor_id" in Input.get_joy_info(device_id):
			var joy_vendor_id = Input.get_joy_info(device_id)["vendor_id"]
			if joy_vendor_id in vendors_ids:
				return vendors_ids[joy_vendor_id]
			else:
				return CONTROLLERS_BRANDS.GENERIC
		else:
			return CONTROLLERS_BRANDS.MISSING
	else:
		return CONTROLLERS_BRANDS.MISSING

func _ready() -> void:
	var player_1 = PLAYER.instantiate()
	player_1.device_id = -2
	player_1.global_position = Vector2(500,400)
	players.append(player_1)
	var player_2 = PLAYER.instantiate()
	player_2.device_id = 0
	player_2.global_position = Vector2(200,400)
	player_2.color = "Green"
	players.append(player_2)
	#player_1.enemy = player_2
	#player_2.enemy = player_1
	var player_3 = PLAYER.instantiate()
	player_3.device_id = 1
	player_3.global_position = Vector2(500,500)
	player_3.color = "Black"
	players.append(player_3)
	var player_4 = PLAYER.instantiate()
	player_4.device_id = 2
	player_4.global_position = Vector2(500,500)
	player_4.color = "Red"
	players.append(player_4)

	@warning_ignore("int_as_enum_without_cast")
	var player_count: PLAYER_COUNT = len(players)-1
	
	match player_count:
		PLAYER_COUNT.ONE:
			pass
		PLAYER_COUNT.TWO:
			pass
		PLAYER_COUNT.THREE:
			pass
