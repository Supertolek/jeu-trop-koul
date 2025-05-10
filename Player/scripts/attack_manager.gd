extends Node2D

signal attack_finished
var is_attacking: bool = false

var current_combo: int = 0:
	set(value):
		current_combo = value
		if value == 0:
			attack_finished.emit()
var is_holding: bool = false

var is_holding_long_enought: bool = false
	

var charged_attack_1_is_charged: bool = false

var attack_1_duration = 0.8
var attack_2_duration = 0.5
var attack_3_duration = 0.8

var attack_1_in_cooldown: bool = false:
	set(value):
		attack_1_in_cooldown = value
		if value:
			attack_1_cooldown_timer.start()
var attack_2_in_cooldown: bool = false:
	set(value):
		attack_2_in_cooldown = value
		if value:
			attack_2_cooldown_timer.start()
var attack_3_in_cooldown: bool = false:
	set(value):
		attack_3_in_cooldown = value
		if value:
			attack_3_cooldown_timer.start()
var attack_1_combo_in_cooldown: bool = false:
	set(value):
		attack_1_combo_in_cooldown = value
		if value:
			attack_1_combo_timer.start()
var attack_2_combo_in_cooldown: bool = false:
	set(value):
		attack_2_combo_in_cooldown = value
		if value:
			attack_2_combo_timer.start()
@onready var player_animation: Node2D = %PlayerAnimation

@onready var attack_1_cooldown_timer: Timer = %Attack1CooldownTimer
@onready var attack_2_cooldown_timer: Timer = %Attack2CooldownTimer
@onready var attack_3_cooldown_timer: Timer = %Attack3CooldownTimer
@onready var attack_1_combo_timer: Timer = %Attack1ComboTimer
@onready var attack_2_combo_timer: Timer = %Attack2ComboTimer

@onready var charged_attack_1_charge_timer: Timer = %ChargedAttack1ChargeTimer
@onready var charged_attack_1_cooldown_timer: Timer = %ChargedAttack1CooldownTimer


func attack_keep_pressed():
	if current_combo == 0:
		is_attacking = true
		is_holding = true
		current_combo = -1
		charged_attack_1_charge_timer.start()
		player_animation.state = 'start_charge_attack_1'
		await get_tree().create_timer(0.2).timeout
		is_holding_long_enought = true

func attack_pressed():
	
	is_attacking = true
	is_holding = true
	if current_combo == 0:
		charged_attack_1_charge_timer.start()
		player_animation.state = 'start_charge_attack_1'
		await get_tree().create_timer(0.2).timeout
		is_holding_long_enought = true
		
func attack_released():
	charged_attack_1_charge_timer.stop()
	if attack_1_in_cooldown or attack_2_in_cooldown or attack_3_in_cooldown:
		return
	if charged_attack_1_is_charged:
		charged_attack_1_cooldown_timer.start()
		player_animation.state = 'charged_attack_1'
		charged_attack_1_is_charged = false
		is_holding = false
		return
		
	match current_combo:
		-1:
			attack_1_in_cooldown = true
			attack_1_combo_in_cooldown = true
			current_combo = 1
			is_holding_long_enought = true
		0:
			attack_1_in_cooldown = true
			attack_1_combo_in_cooldown = true
			current_combo = 1
			is_holding_long_enought = true
		1:
			attack_2_in_cooldown = true
			attack_2_combo_in_cooldown = true
			current_combo = 2
			is_holding_long_enought = true
		2:
			attack_3_in_cooldown = true
			current_combo = 3
			is_holding_long_enought = true
	player_animation.state = 'attack_'+str(current_combo)
	is_holding = false



func _on_attack_1_cooldown_timer_timeout() -> void:
	attack_1_in_cooldown = false
	is_holding_long_enought = false


func _on_attack_2_cooldown_timer_timeout() -> void:
	attack_2_in_cooldown = false
	is_holding_long_enought = false


func _on_attack_3_cooldown_timer_timeout() -> void:
	attack_3_in_cooldown = false
	is_holding_long_enought = false
	current_combo = 0
	is_attacking = false


func _on_attack_1_combo_timer_timeout() -> void:
	attack_1_combo_in_cooldown = false
	if !attack_2_in_cooldown:
		current_combo = 0
		is_attacking = false


func _on_attack_2_combo_timer_timeout() -> void:
	attack_2_combo_in_cooldown = false
	if !attack_3_in_cooldown:
		current_combo = 0
		is_attacking = false


func _on_charged_attack_1_charge_timer_timeout() -> void:
	if is_holding:
		charged_attack_1_is_charged = true


func _on_charged_attack_1_cooldown_timer_timeout() -> void:
	current_combo = 0
	is_attacking = false
	is_holding_long_enought = false
