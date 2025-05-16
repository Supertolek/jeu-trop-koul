extends Node2D

class_name AttackManager


@onready var player: Player = owner
@onready var player_state_machine: PlayerStateMachine = %PlayerStateMachine

# Areas
@onready var player_hit_box_area: Area2D = %player_hit_box_area
@onready var attack_1_area: Area2D = %attack_1_area
@onready var attack_2_area: Area2D = %attack_2_area
@onready var attack_3_area: Area2D = %attack_3_area
@onready var charged_attack_area: Area2D = %charged_attack_area

# Basic Attack Timer
@onready var attack_1_cooldown_timer: Timer = %Attack1CooldownTimer
@onready var attack_2_cooldown_timer: Timer = %Attack2CooldownTimer
@onready var attack_3_cooldown_timer: Timer = %Attack3CooldownTimer
@onready var combo_timer: Timer = %ComboTimer
@onready var animation_timer: Timer = %AnimationTimer

# Charched Attack Timer
@onready var charged_attack_1_charge_timer: Timer = %ChargedAttack1ChargeTimer
@onready var charged_attack_1_cooldown_timer: Timer = %ChargedAttack1CooldownTimer
var attack_1_animation_duration: float = 0.8
var attack_2_animation_duration: float = 0.5
var attack_3_animation_duration: float = 0.8
var charged_attack_animation_duration: float = 1.1
	
var attack_1_duration_cooldown: float = 0.5:
	set(value):
		attack_1_duration_cooldown = value
		attack_1_cooldown_timer.wait_time = value
var attack_2_duration_cooldown: float = 0.4:
	set(value):
		attack_2_duration_cooldown = value
		attack_2_cooldown_timer.wait_time = value
var attack_3_duration_cooldown: float = 0.7:
	set(value):
		attack_3_duration_cooldown = value
		attack_3_cooldown_timer.wait_time = value
var combo_1_time_window:float = 0.5
var combo_2_time_window:float = 0.5

var can_special:bool = false


func _ready() -> void:
	attack_1_duration_cooldown = attack_1_duration_cooldown
	attack_2_duration_cooldown = attack_2_duration_cooldown
	attack_3_duration_cooldown = attack_3_duration_cooldown

var is_attack_animation_played: bool = false:
	set(value):
		is_attack_animation_played = value
var combo_points: int = 3
var is_holding:bool = false
var attack_posible: bool = true
var combo_1_enable: bool = false
var combo_2_enable: bool = false
var saved_direction: GlobalPlayerMgmt.PLAYER_DIRECTION
var is_attack_direction_locked:bool = false
var locked_attack_direction: GlobalPlayerMgmt.PLAYER_DIRECTION

func stop_attack():
	combo_points =3


func _process(_delta: float) -> void:
	if player.is_hurt:
		attack_released()
	if is_holding:
		if !is_attack_animation_played and\
		 player_state_machine.state != GlobalPlayerMgmt.PLAYER_STATE.CHARGE_ATTACK and\
		 player_state_machine.state != GlobalPlayerMgmt.PLAYER_STATE.CAST_CHARGED_ATTACK:
			player_state_machine.state = GlobalPlayerMgmt.PLAYER_STATE.CHARGE_ATTACK
			charged_attack_1_charge_timer.start()
		
func attack_pressed():
	is_holding = true

func attack_released():
	if player.is_hurt: return
	is_holding = false
	if !attack_posible: return
	disble_attack()
	charged_attack_1_charge_timer.stop()
	is_attack_animation_played = true
	if can_special:
		player_state_machine.state = GlobalPlayerMgmt.PLAYER_STATE.CAST_CHARGED_ATTACK
		charged_attack_1_cooldown_timer.start()
		animation_timer.start(charged_attack_animation_duration)
		can_special = false
		return
		
	match combo_points:
		3:
			player_state_machine.state = GlobalPlayerMgmt.PLAYER_STATE.ATTACK_1
			#directionate_attack(attack_1_area)
			attack_1_cooldown_timer.start()
			combo_timer.start(attack_1_duration_cooldown + combo_1_time_window)
			animation_timer.start(attack_1_animation_duration)
		2:
			player_state_machine.state = GlobalPlayerMgmt.PLAYER_STATE.ATTACK_2
			#directionate_attack(attack_2_area)
			attack_2_cooldown_timer.start()
			combo_timer.start(attack_2_duration_cooldown + combo_2_time_window)
			animation_timer.start(attack_2_animation_duration)
		1:
			player_state_machine.state = GlobalPlayerMgmt.PLAYER_STATE.ATTACK_3
			#directionate_attack(attack_3_area)
			attack_3_cooldown_timer.start()
			animation_timer.start(attack_3_animation_duration)
	


func enable_attack():
	attack_posible = true
	if player.is_moving:
		if player.device_id >= 0:
			player.facing_direction = player.memory_facing_direction
		else:
			player.facing_direction = saved_direction
		

func disble_attack():
	attack_posible = false
	
func lock_attack_direction():
	is_attack_direction_locked = true
	locked_attack_direction = player.facing_direction

func unlock_attack_direction():
	is_attack_direction_locked = false


	
	


func _on_attack_1_cooldown_timer_timeout() -> void:
	directionate_attack(attack_1_area, true)
	combo_points -= 1
	enable_attack()

func _on_attack_2_cooldown_timer_timeout() -> void:
	directionate_attack(attack_2_area, true)
	combo_points -= 1
	enable_attack()

func _on_attack_3_cooldown_timer_timeout() -> void:
	directionate_attack(attack_3_area, true)
	combo_points = 3
	enable_attack()
	
func _on_combo_timer_timeout() -> void:
	if attack_posible:
		combo_points = 3

func _on_animation_timer_timeout() -> void:
	is_attack_animation_played = false
	if !player.is_moving:
		player.facing_direction = saved_direction
	
func _on_charged_attack_1_charge_timer_timeout() -> void:
	can_special = true

func _on_charged_attack_1_cooldown_timer_timeout() -> void:
	combo_points = 3
	enable_attack()




		
func directionate_attack(attack_area, reset:bool = false):
	if attack_area is int:
		attack_area = get_child(-4+attack_area)
	if reset:
		attack_area.visible = false
		for hit_box in attack_area.get_children():
			hit_box.disabled = true
		return
	attack_area.visible = true
	saved_direction = player_state_machine.get_attack_direction()
	if player.device_id >= 0 and is_attack_direction_locked: 
		saved_direction = locked_attack_direction
	if attack_area == charged_attack_area:
		attack_area.get_node("collision").disabled = false
		return	
	match saved_direction:
		GlobalPlayerMgmt.PLAYER_DIRECTION.UP:
			attack_area.get_node("up").disabled = false
		GlobalPlayerMgmt.PLAYER_DIRECTION.DOWN:
			attack_area.get_node("down").disabled = false
		GlobalPlayerMgmt.PLAYER_DIRECTION.LEFT:
			attack_area.get_node("left").disabled = false
		GlobalPlayerMgmt.PLAYER_DIRECTION.RIGHT:
			attack_area.get_node("right").disabled = false
		



func _on_attack_1_area_area_entered(area: Area2D) -> void:
	if area is PlayerHitBoxArea:
		if area == player_hit_box_area: return
		owner.hit_player(area.owner)


func _on_attack_2_area_area_entered(area: Area2D) -> void:
	if area is PlayerHitBoxArea:
		if area == player_hit_box_area: return
		owner.hit_player(area.owner, 1.1)


func _on_attack_3_area_area_entered(area: Area2D) -> void:
	if area is PlayerHitBoxArea:
		if area == player_hit_box_area: return
		owner.hit_player(area.owner, 1.3)


func _on_charged_attack_area_area_entered(area: Area2D) -> void:
	if area is PlayerHitBoxArea:
		if area == player_hit_box_area: return
		owner.hit_player(area.owner, 1.3)
