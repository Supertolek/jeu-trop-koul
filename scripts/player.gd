extends CharacterBody2D

var player_scale: int = 4


var max_speed: int = 55 * player_scale
var acceleration: int = 5 * player_scale
var friction: int = 8 * player_scale
var base_stats: Dictionary[Global.STATS, int] = {
	Global.STATS.FORCE:10,
	Global.STATS.DEFENSE:5,
	Global.STATS.HEALTH:100,
}
var effective_stats: Dictionary[Global.STATS, int]
@export var item_list: Array[Item]:
	set(value):
		print(value)
		item_list = value
		if !Engine.is_editor_hint():
			effective_stats = apply_item()

func _ready() -> void:
	effective_stats = apply_item()
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('ui_accept'):
		print(effective_stats)

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"),
	).normalized()
	
	var lerp_weight = delta * (acceleration if direction else friction)
	velocity = lerp(velocity, max_speed * direction, lerp_weight)
	
	move_and_slide()


func apply_item():
	var local_effective_stats = base_stats.duplicate()
	for item in item_list:
		for stats in item.stats_modification.keys():
			var value = item.stats_modification[stats]
			#if !effective_stats[stats]: 
		#		effective_stats[stats] = 0
			local_effective_stats[stats] += value
		print(item.name)
	return local_effective_stats
