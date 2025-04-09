class_name Player
extends Character 

var max_speed: int = 55 * player_scale
var acceleration: int = 5 * player_scale
var friction: int = 8 * player_scale

var device_id: int = -2

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
		
	
	var lerp_weight = delta * (acceleration if direction else friction)
	velocity = lerp(velocity, max_speed * direction, lerp_weight)
	
	move_and_slide()
