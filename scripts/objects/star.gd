@tool
extends Area2D

class_name StarObjects
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var sprite: Sprite2D = %Sprite2D


@export var star_color: GlobalObjectsMgmt.STAR_COLOR = GlobalObjectsMgmt.STAR_COLOR.SILVER:
	set(value):
		star_color = value
		update_frame()
		
@export_group("Internal")
@export var animation_x: int = 0:
	set(value):
		if sprite:
			sprite.frame_coords.x = value
		animation_x = value
@export_tool_button("Spin") var spin_button = spin
@export_tool_button("Collect") var collect_button = collect
@export_tool_button("Stop Animation") var stop_animation_button = stop_animation


func update_frame():
		if sprite:
				sprite.frame_coords.y = star_color
	

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		GameController.star_collected(star_color)
		collect()
func spin():
	animation_player.play("spin")
	
		
func collect():
	animation_player.play("collect")

func stop_animation():
	animation_player.stop()
	animation_x = 0

func _on_mouse_entered() -> void:
	#collect()
	pass
