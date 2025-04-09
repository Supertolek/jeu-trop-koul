class_name Ennemy
extends Character

@export var target_player : Player
var speed =20

func _physics_process(delta: float) -> void:
	if target_player:
		var delta_pos : Vector2 = (target_player.position - position).normalized()*speed
		position += delta_pos
