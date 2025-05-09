extends Node2D

signal attack_finished

var current_combo: int = 0:
	set(value):
		current_combo = value
		if value == 0:
			attack_finished.emit()


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

func attack():
	if attack_1_in_cooldown or attack_2_in_cooldown or attack_3_in_cooldown:
		return
	match current_combo:
		0:
			attack_1_in_cooldown = true
			attack_1_combo_in_cooldown = true
			current_combo = 1
		1:
			attack_2_in_cooldown = true
			attack_2_combo_in_cooldown = true
			current_combo = 2
		2:
			attack_3_in_cooldown = true
			current_combo = 3
	player_animation.state = 'attack_'+str(current_combo)




func _on_attack_1_cooldown_timer_timeout() -> void:
	attack_1_in_cooldown = false


func _on_attack_2_cooldown_timer_timeout() -> void:
	attack_2_in_cooldown = false


func _on_attack_3_cooldown_timer_timeout() -> void:
	attack_3_in_cooldown = false
	current_combo = 0


func _on_attack_1_combo_timer_timeout() -> void:
	attack_1_combo_in_cooldown = false
	if !attack_2_in_cooldown:
		current_combo = 0


func _on_attack_2_combo_timer_timeout() -> void:
	attack_2_combo_in_cooldown = false
	if !attack_3_in_cooldown:
		current_combo = 0
