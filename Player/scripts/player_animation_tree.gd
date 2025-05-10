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
var direction: String = '_down':
	set(value):
		if value != direction:
			var actual_time = animation_player.current_animation_position
			direction = value
			play(state,actual_time)
			
		
var attack_direction: String

func _ready() -> void:
	pass


func _process(_delta: float) -> void: 

	if player.velocity.length()>=0.3:
		var angle = rad_to_deg(atan2(player.velocity.x, player.velocity.y))
		if -45 <= angle and angle < 45:
			direction = '_down'
		elif 45 <= angle and angle < 135:
			direction = '_right'
		elif 135 <= angle or angle < -135:
			direction = '_up'
		elif -135 <= angle and angle < -45:
			direction = '_left'
		if !attack_manager.is_attacking:
			state = 'run'
	else:
		if !attack_manager.is_attacking:
			state = "idle"
		
		
			
func get_attack_direction():
	var mouse_coord:= get_global_mouse_position()-player.global_position
	var angle = rad_to_deg(atan2(mouse_coord.x, mouse_coord.y))
	
	if -45 <= angle and angle < 45:
		return '_down'
	elif 45 <= angle and angle < 135:
		return '_right'
	elif 135 <= angle or angle < -135:
		return '_up'
	elif -135 <= angle and angle < -45:
		return '_left'
	

func play(animation:String, start_time=-1):
	if animation in ["falling","raising","standby"]:
		animation_player.play(animation)
	elif animation.contains('attack'):
		animation_player.play_section(animation + direction,start_time)
	else:
		animation_player.play_section(animation + direction,start_time)
		
		
	if start_time != -1:
		animation_player.reset_section()
		
