class_name Player
extends Character 

var max_speed: int = 55 * player_scale
var acceleration: int = 5 * player_scale
var friction: int = 8 * player_scale

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"),
	).normalized()
	
	var lerp_weight = delta * (acceleration if direction else friction)
	velocity = lerp(velocity, max_speed * direction, lerp_weight)
	
	move_and_slide()
