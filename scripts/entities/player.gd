
class_name Player
extends Character 

var max_speed: int = 45 * player_scale
var acceleration: int = 7 * player_scale
var friction: int = 10 * player_scale
var is_moving: bool = false
var device_id: int = -2
@onready var sprite: Sprite2D = %Sprite
@onready var attack_manager: Node2D = %AttackManager
@export_enum('Blue','Green','Black','Red') var color: String = 'Blue'

func _ready() -> void:
	calculate_all_stats(false)
	
func _physics_process(delta: float) -> void:
	var direction: Vector2
	if device_id  == -2:
		direction = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_down") - Input.get_action_strength("move_up"),
		).normalized()
	elif device_id >= 0:
		direction = Vector2(
			Input.get_joy_axis(device_id, JOY_AXIS_LEFT_X),
			Input.get_joy_axis(device_id, JOY_AXIS_LEFT_Y),
		)
		if direction.length() <= 0.15:
			direction = Vector2.ZERO
	if direction:
		is_moving = true
	else:
		is_moving = false
	
	var lerp_weight = delta * (acceleration if direction else friction)
	velocity = lerp(velocity, max_speed * direction, lerp_weight)
	
	move_and_slide()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		attack_manager.attack()









var inventory_storage: Dictionary = {
	"equiped_weapon" : load("res://Resources/Items/Weapon/test_sword.tres").duplicate(),
	"equiped_armor": load("res://Resources/Items/Armor/a_cool_chestplate.tres").duplicate(),
	"inventory": [
		preload("res://Resources/Items/Items_Modifiers/ham.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/attack_of_some.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/bread.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/attack_of_some.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/attack_of_some.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/ham.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/bread.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/bread.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/ham.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/attack_of_some.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/pile_of_coin.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/ham.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/attack_of_some.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/bread.tres").duplicate(),
	]
}

var player_stats: StatsSheet = StatsSheet.new()

func calculate_all_stats(display_in_console:bool = false):
	var equipements = [GlobalItemsMgmt.default_player_stats]
	var current_armor: Armor = inventory_storage['equiped_armor']
	equipements.append(current_armor)
	var current_weapon: Weapon = inventory_storage['equiped_weapon']
	equipements.append(current_weapon)
	var calculated_stats: StatsSheet = StatsSheet.new()
	for equipement  in equipements:
		match equipement.class_type:
			GlobalItemsMgmt.TYPE_OF_ITEMS.WEAPON:
				if display_in_console: print(equipement.name.to_upper())
				calculated_stats = GlobalItemsMgmt.merge_stats_sheet(calculated_stats,equipement.calculate_stats(display_in_console),display_in_console)
			GlobalItemsMgmt.TYPE_OF_ITEMS.ARMOR:
				if display_in_console: print(equipement.name.to_upper())
				calculated_stats = GlobalItemsMgmt.merge_stats_sheet(calculated_stats,equipement.calculate_stats(display_in_console),display_in_console)

			GlobalItemsMgmt.TYPE_OF_ITEMS.STATS_SHEET:
				if display_in_console: print('Base Stats'.to_upper())
				calculated_stats = GlobalItemsMgmt.merge_stats_sheet(calculated_stats,equipement,display_in_console)
	GlobalItemsMgmt.display_stats_sheet(calculated_stats)
	player_stats = calculated_stats
