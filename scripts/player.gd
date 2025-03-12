extends CharacterBody2D

var player_scale: int = 4

var max_speed: int = 55 * player_scale
var acceleration: int = 5 * player_scale
var friction: int = 3 * player_scale

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"),
	).normalized()
	
	var lerp_weight = delta * (acceleration if direction else friction)
	velocity = lerp(velocity, max_speed * direction, lerp_weight)
	
	move_and_slide()
