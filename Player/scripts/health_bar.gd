@tool
@icon("res://assets/Nodes Icons/bar.svg")
extends Control

class_name HealthBar
@onready var damage_display: NinePatchRect = %DamageDisplay
@onready var health_display: NinePatchRect = %HealthDisplay

@onready var damage_timer: Timer = %DamageTimer

var actual_speed: float = 0.3
var damage_speed: float = 1

var health_tween_value: float = 100:
	set(value):
		health_tween_value = value
		health_display.size.x = value
		if value <= 5:
			health_display.position.x = 9+value
var damage_tween_value: float = 100:
	set(value):
		damage_tween_value = value
		damage_display.size.x = value
		if value <= 5:
			damage_display.position.x = 9+value

var health_tween: Tween
var damage_tween: Tween


@export var max_health: float = 200
@export var min_health: float = 0
@export var health: float = 200:
	set(value):
		value = min(value,max_health)
		value = max(value,min_health)
		
		var delta_health = value - health
		health = value
		if delta_health > 0:
			display_regen()
		elif delta_health < 0:
			display_damage()

func init_bar(_min_health,_max_health,_health=null):
	max_health = _max_health
	min_health = _min_health
	if _health:
		health = _health
		damage_tween_value = _health
		health_tween_value = _health
	else:
		health = max_health
		damage_tween_value = _max_health
		health_tween_value = _max_health
func _process(_delta: float) -> void:
	pass
	
func display_damage():
	if !health_tween or !health_tween.is_running() and damage_display.size.x < health_display.size.x:
		damage_display.size.x = health_display.size.x
	health_tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
	health_tween.tween_property(self, 'health_tween_value', (health*100)/max_health, actual_speed)
	if damage_tween and damage_tween.is_running():
		damage_tween.kill()
	damage_timer.start()

func _on_damage_timer_timeout() -> void:
	damage_tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
	damage_tween.tween_property(self, 'damage_tween_value', (health*100)/max_health,damage_speed)
	
func display_regen():
	health_tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
	health_tween.tween_property(self, 'health_tween_value', (health*100)/max_health, actual_speed)
	
