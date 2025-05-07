@tool
extends StaticBody2D

class_name PadlockObjects

@onready var sprite: Sprite2D = %Sprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D


@export var padlock_color: GlobalObjectsMgmt.KEY_COLOR = GlobalObjectsMgmt.KEY_COLOR.RED:
	set(value):
		padlock_color = value
		update_frame()
		
@export var padlock_glow: bool = false:
	set(value):
		padlock_glow = value
		update_frame()
			
@export_group("Internal")
@export var animation_x: int = 0:
	set(value):
		if sprite:
			sprite.frame_coords.x = value
		animation_x = value
@export_tool_button("Unlock") var unlock_button = unlock
@export_tool_button("Stop Animation") var stop_animation_button = stop_animation


func update_frame():
		if sprite:
			if padlock_glow:
				sprite.frame_coords.y = 2*padlock_color + 1
			else:
				sprite.frame_coords.y = 2*padlock_color

func unlock():
	animation_player.play("unlock")

	
func stop_animation():
	animation_player.stop()
	animation_x = 0
	sprite.frame_coords.y = 4 * int(padlock_color)
	
