extends Node2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var attack_manager: Node2D = %AttackManager

@export var animation_tree: AnimationTree
@export var player: Player

@onready var sprite: Sprite2D = %Sprite
var state: String = 'idle':
	set(value):
		if value != state:
			play(value)
		state = value

var last_facing_direction: Vector2 = Vector2(0,-1)
		
var attack_direction: String

func _ready() -> void:
	pass


func _process(_delta: float) -> void: 

	if player.velocity.length()>=0.3:
		if attack_manager.is_holding_long_enought and !attack_manager.charged_attack_1_is_charged: return
		if attack_manager.is_attack_animation_playing() and !attack_manager.charged_attack_1_is_charged:
			state = 'run'
		var angle = rad_to_deg(atan2(player.velocity.x, player.velocity.y))
		if -45 <= angle and angle < 45:
			player.direction = 'down'
		elif 45 <= angle and angle < 135:
			player.direction = 'right'
		elif 135 <= angle or angle < -135:
			player.direction = 'up'
		elif -135 <= angle and angle < -45:
			player.direction = 'left'
		if !attack_manager.is_attacking:
			state = 'run'
	else:
		if !attack_manager.is_attacking:
			state = "idle"
		
		
			
func get_attack_direction():
	var mouse_coord:= get_global_mouse_position()-player.global_position
	var angle = rad_to_deg(atan2(mouse_coord.x, mouse_coord.y))
	
	if -45 <= angle and angle < 45:
		return 'down'
	elif 45 <= angle and angle < 135:
		return 'right'
	elif 135 <= angle or angle < -135:
		return 'up'
	elif -135 <= angle and angle < -45:
		return 'left'
	

func play(animation:String, start_time=-1):
	if animation in ["falling","raising","standby"]:
		animation_player.play(animation)
	elif animation.contains('attack'):
		animation_player.play_section(animation + '_' + player.direction,start_time)
	else:
		animation_player.play_section(animation + '_' + player.direction,start_time)
		
		
	if start_time != -1:
		animation_player.reset_section()
		
