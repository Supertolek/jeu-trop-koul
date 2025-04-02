extends CharacterBody2D

var player_scale: int = 4

var max_speed: int = 55 * player_scale
var acceleration: int = 5 * player_scale
var friction: int = 8 * player_scale

var is_attacking:bool = false
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@export var weapon_group: Node2D
@export var sweapAttackSprite: Sprite2D
func _ready() -> void:
	toggle_2d_collision_shape_visibility()

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"),
	).normalized()
	
	var lerp_weight = delta * (acceleration if direction else friction)
	velocity = lerp(velocity, max_speed * direction, lerp_weight)
	
	move_and_slide()
	
func _process(_delta: float) -> void:
	#if global_position.x - get_global_mouse_position().x > 0:
		#sweapAttackSprite.flip_v = true
	#else:
		#sweapAttackSprite.flip_v = false
	weapon_group.look_at(get_global_mouse_position())

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		if not is_attacking:
			is_attacking = true
				
			animation_player.play("sweap_attack")
			
func _attack_end():
	is_attacking = false
	
func toggle_2d_collision_shape_visibility() -> void:
	var tree := get_tree()
	tree.debug_collisions_hint = not tree.debug_collisions_hint

	# Traverse tree to call queue_redraw on instances of
	# CollisionShape2D and CollisionPolygon2D.
	var node_stack: Array[Node] = [tree.get_root()]
	while not node_stack.is_empty():
		var node: Node = node_stack.pop_back()
		if is_instance_valid(node):
			if node is CollisionShape2D or node is CollisionPolygon2D:
				node.queue_redraw()
			node_stack.append_array(node.get_children())
