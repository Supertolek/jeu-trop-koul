@tool
extends Area2D

class_name CoinObjects
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var sprite: Sprite2D = %Sprite2D


@export var coin_color: GlobalObjectsMgmt.COIN_COLOR = GlobalObjectsMgmt.COIN_COLOR.GREY:
	set(value):
		coin_color = value
		update_frame()
		
@export var coin_glow: bool = false:
	set(value):
		coin_glow = value
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
			if coin_glow:
				sprite.frame_coords.y = 2*coin_color + 1
			else:
				sprite.frame_coords.y = 2*coin_color
	

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		GameController.coin_collected(coin_color)
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
