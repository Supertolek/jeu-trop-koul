extends Node2D
class_name PlayerStateMachine

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var attack_manager: AttackManager = %AttackManager
@onready var player: Player = owner


@export var state: GlobalPlayerMgmt.PLAYER_STATE = GlobalPlayerMgmt.PLAYER_STATE.IDLE:
	set(value):
		if value != state:
			play(value)
		state = value

		

func _ready() -> void:
	pass


func _process(_delta: float) -> void: 
	if player.is_hurt or player.is_dead: return
	if attack_manager.is_attack_animation_played or attack_manager.is_holding: 
		return
	if player.is_moving:
		state = GlobalPlayerMgmt.PLAYER_STATE.RUNNING
	else:
		state = GlobalPlayerMgmt.PLAYER_STATE.IDLE
		
		
			
func get_attack_direction():
	if player.device_id >= 0:
		if attack_manager.is_attack_direction_locked: 
			return attack_manager.locked_attack_direction
		return player.get_facing_direction()
	# Calculate attack direction
	var mouse_coord := ((get_global_mouse_position() - player.linked_viewport_container.global_position)
		/ (player.linked_viewport_container.scale)) - player.global_position
	var angle = mouse_coord.rotated(PI/4).angle()
	if 0 <= angle and angle < PI/2:
		return GlobalPlayerMgmt.PLAYER_DIRECTION.RIGHT
	elif PI/2 <= angle and angle < PI:
		return GlobalPlayerMgmt.PLAYER_DIRECTION.DOWN
	elif -PI <= angle and angle < -PI/2:
		return GlobalPlayerMgmt.PLAYER_DIRECTION.LEFT
	elif -PI/2 <= angle and angle < 0:
		return GlobalPlayerMgmt.PLAYER_DIRECTION.UP
	

func play(animation:GlobalPlayerMgmt.PLAYER_STATE, start_time=-1):
	var facing_direction_string: String = GlobalPlayerMgmt.get_direction_string(player.facing_direction)
	var mouse_direction_string: String = GlobalPlayerMgmt.get_direction_string(get_attack_direction())
	match animation:
		GlobalPlayerMgmt.PLAYER_STATE.IDLE:
			animation_player.play_section("idle_" + facing_direction_string, start_time)
		GlobalPlayerMgmt.PLAYER_STATE.RUNNING:
			animation_player.play_section("run_" + facing_direction_string, start_time)
		GlobalPlayerMgmt.PLAYER_STATE.HURT:
			animation_player.play_section("hit_" + facing_direction_string, start_time)
		GlobalPlayerMgmt.PLAYER_STATE.DIE:
			animation_player.play_section("die_" + facing_direction_string, start_time)
		GlobalPlayerMgmt.PLAYER_STATE.FALLING:
			animation_player.play("falling")
		GlobalPlayerMgmt.PLAYER_STATE.STANDBY:
			animation_player.play("standby")
		GlobalPlayerMgmt.PLAYER_STATE.RAISING:
			animation_player.play("raising")
		GlobalPlayerMgmt.PLAYER_STATE.ATTACK_1:
			animation_player.play("attack_1_" + mouse_direction_string)
		GlobalPlayerMgmt.PLAYER_STATE.ATTACK_2:
			animation_player.play("attack_2_" + mouse_direction_string)
		GlobalPlayerMgmt.PLAYER_STATE.ATTACK_3:
			animation_player.play("attack_3_" + mouse_direction_string)
		GlobalPlayerMgmt.PLAYER_STATE.CHARGE_ATTACK:
			animation_player.play("start_charge_attack_1_" + facing_direction_string)
		GlobalPlayerMgmt.PLAYER_STATE.CAST_CHARGED_ATTACK:
			animation_player.play("charged_attack_1_" + mouse_direction_string)
		
	if start_time != -1:
		animation_player.reset_section()
		
