@tool
extends StaticBody2D

class_name VaseObjects

@onready var sprite: Sprite2D = %Sprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

@export var vase_color: GlobalObjectsMgmt.VASE_COLOR = GlobalObjectsMgmt.VASE_COLOR.LIGHT:
	set(value):
		if sprite:
			sprite.frame_coords.y = 4 * int(value)
		vase_color = value
		
		
@export_group("Internal")
@export var animation_x: int = 0:
	set(value):
		if sprite:
			sprite.frame_coords.x = value
		animation_x = value
		
@export_tool_button("Shine") var shine_button = shine
@export_tool_button("Explode") var explode_button = explode
@export_tool_button("Hit Left") var hit_left_button = hit.bind(GlobalObjectsMgmt.DIRECTION.LEFT)
@export_tool_button("Hit Right") var hit_right_button = hit.bind(GlobalObjectsMgmt.DIRECTION.RIGHT)
@export_tool_button("Break Left") var broke_left_button = broke.bind(GlobalObjectsMgmt.DIRECTION.LEFT)
@export_tool_button("Break Right") var broke_right_button = broke.bind(GlobalObjectsMgmt.DIRECTION.RIGHT)
@export_tool_button("Stop Animation") var stop_animation_button = stop_animation



func shine():
	sprite.frame_coords.y = 4 * int(vase_color)
	animation_player.play("shine")

func hit(direction: GlobalObjectsMgmt.DIRECTION):
	sprite.frame_coords.y = 4 * int(vase_color) + 2
	var dir: String = "from_left"
	match direction:
		GlobalObjectsMgmt.DIRECTION.LEFT:
			dir = "from_left"
		GlobalObjectsMgmt.DIRECTION.RIGHT:
			dir = "from_right"
	animation_player.play(dir)

func broke(direction: GlobalObjectsMgmt.DIRECTION):
	sprite.frame_coords.y = 4 * int(vase_color) + 3
	var dir: String = "from_left"
	match direction:
		GlobalObjectsMgmt.DIRECTION.LEFT:
			dir = "from_left"
		GlobalObjectsMgmt.DIRECTION.RIGHT:
			dir = "from_right"
	animation_player.play(dir)
	

func explode():
	sprite.frame_coords.y = 4 * int(vase_color) + 1
	animation_player.play("shine")
	
func stop_animation():
	animation_player.stop()
	animation_x = 0
	sprite.frame_coords.y = 4 * int(vase_color)
	
