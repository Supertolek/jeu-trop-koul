
class_name Player
extends Character 

var max_speed: int = 45 * player_scale
var acceleration: int = 7 * player_scale
var friction: int = 10 * player_scale
var is_moving: bool = false
@export var device_id: int
@onready var sprite: Sprite2D = %Sprite
@onready var attack_manager: Node2D = %AttackManager
@onready var player_animation: Node2D = %PlayerAnimation


var direction: String = 'down':
	set(value):
		if value != direction:
			var actual_time = player_animation.animation_player.current_animation_position
			direction = value
			player_animation.play(player_animation.state,actual_time)

@onready var health_regeneration_timer: Timer = %HealthRegenerationTimer

@export_enum('Blue','Green','Black','Red') var color: String = 'Blue'
var enemy: Player

var hold_actions:Array[String] = []

@export var frozen: bool = false

@onready var linked_camera: Camera2D = $RoomCamera

func get_camera() -> Camera2D:
	return $RoomCamera


func _ready() -> void:
	calculate_all_stats(false)
	player_stats.stat_effective_health = player_stats.stat_max_health
	
	
func _physics_process(delta: float) -> void:
	if not frozen:
		var direction: Vector2
		if device_id == -2:
			direction = Vector2(
				Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
				Input.get_action_strength("move_down") - Input.get_action_strength("move_up"),
			).normalized()
		elif device_id >= 0:
			direction = Vector2(
				Input.get_joy_axis(device_id, JOY_AXIS_LEFT_X),
				Input.get_joy_axis(device_id, JOY_AXIS_LEFT_Y),
			).normalized()
			if direction.length() <= 0.3:
				direction = Vector2.ZERO
		if attack_manager.charged_attack_1_is_charged:
			direction /= 4
		if direction:
			is_moving = true
		else:
			is_moving = false
		
		var lerp_weight = delta * (acceleration if direction else friction)
		velocity = lerp(velocity, max_speed * direction, lerp_weight)
		
		move_and_slide()

func _process(_delta: float) -> void:
	if "attack" in hold_actions:
		attack_manager.attack_keep_pressed()
		
		
func _input(event: InputEvent) -> void:
	# Gros if statement pour séparer les inputs des joueurs
	if (!(event is InputEventKey or event is InputEventMouse) and device_id == -2) or\
	 ((event is InputEventKey or event is InputEventMouse) and device_id >=0) or\
	(device_id >= 0 and event.device != device_id): return
	
	# Mettre les Inputs ici
	
	if event.is_action_pressed("attack"):
		hold_actions.append("attack")
		attack_manager.attack_pressed()
	if event.is_action_released("attack"):
		hold_actions.erase("attack")
		#hit_player(enemy)
		attack_manager.attack_released()
	if event.is_action_pressed("right_click"):
		hit(-1)
		
		
			
		



func hit(damage: float, damage_mult:float = 1):
	var damage_reduction: float = 0
	damage *= damage_mult
	if damage > 0:
		damage_reduction = (player_stats.stat_defense * damage) / (player_stats.stat_defense + 50)
	var effective_damage = snappedf(damage - damage_reduction,0.1)
	player_stats.stat_effective_health = clamp(player_stats.stat_effective_health - effective_damage, 0, player_stats.stat_max_health)

	GameController.health_change(self)
	
func hit_player(target_player: Player, damage_mult:float = 1):
	target_player.hit(GlobalItemsMgmt.calculate_damage(player_stats), damage_mult)


















var is_inventory_open: bool = false
var inventory_storage: Dictionary = {
	"equiped_weapon" :null,# load("res://Resources/Items/Weapon/test_sword.tres").duplicate(),
	"equiped_armor":null,# load("res://Resources/Items/Armor/a_cool_chestplate.tres").duplicate(),
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
		if equipement == null:
			continue
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
	apply_stat()

func apply_stat():
	health_regeneration_timer.wait_time = -log(clamp(player_stats.stat_health_regeneration,0,100))/3 + 2
	print(health_regeneration_timer.wait_time)

func _on_health_regeneration_timer_timeout() -> void:
	hit(-player_stats.stat_max_health/50)
