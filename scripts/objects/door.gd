@tool
extends StaticBody2D

class_name DoorObjects

@export var door_type: GlobalObjectsMgmt.DOOR_TYPE = GlobalObjectsMgmt.DOOR_TYPE.METAL:
	set(value):
		door_type = value
		metal_door.visible = false
		wall_door.visible = false
		wooden_door.visible = false
		match door_type:
			GlobalObjectsMgmt.DOOR_TYPE.METAL:
				metal_door.visible = true
				collision_shape_2d.shape.size = Vector2(16,16)
			GlobalObjectsMgmt.DOOR_TYPE.WALL:
				wall_door.visible = true
				collision_shape_2d.shape.size = Vector2(32,16)
			GlobalObjectsMgmt.DOOR_TYPE.WOODEN:
				wooden_door.visible = true
				collision_shape_2d.shape.size = Vector2(32,16)

@export var door_open_default: bool = false:
	set(value):
		if value:
			open_door()
		else:
			close_door()
		door_open_default = value

@export_group('Internal')
@export_tool_button("Open") var open_button = open_door
@export_tool_button("Close") var close_button = close_door

@onready var metal_door: Sprite2D = %metal_door
@onready var wall_door: Sprite2D = %wall_door
@onready var wooden_door: Sprite2D = %wooden_door
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var metal_animation_player: AnimationPlayer = %metal_animation_player
@onready var wall_animation_player: AnimationPlayer = %wall_animation_player
@onready var wooden_animation_player: AnimationPlayer = %wooden_animation_player
@onready var open: bool = door_open_default



func open_door():
	if open: return
	match door_type:
			GlobalObjectsMgmt.DOOR_TYPE.METAL:
				metal_animation_player.play('open')
			GlobalObjectsMgmt.DOOR_TYPE.WALL:
				wall_animation_player.play('open')
			GlobalObjectsMgmt.DOOR_TYPE.WOODEN:
				wooden_animation_player.play('open')
	door_open_default = true
	open = true
				
		
func close_door():
	if !open: return
	match door_type:
			GlobalObjectsMgmt.DOOR_TYPE.METAL:
				metal_animation_player.play('close')
			GlobalObjectsMgmt.DOOR_TYPE.WALL:
				wall_animation_player.play('close')
			GlobalObjectsMgmt.DOOR_TYPE.WOODEN:
				wooden_animation_player.play('close')
	door_open_default = false
	open = false
		
