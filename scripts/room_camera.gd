extends Camera2D
class_name RoomCamera

@onready var screen_size: Vector2 = get_viewport_rect().size
@export var player_node: CharacterBody2D
@export var offset_size: int = 100

func _ready() -> void:
	set_screen_position()
	#Wait until next frame
	await  get_tree().process_frame
	position_smoothing_enabled = true
	position_smoothing_speed = 7.0


func _process(delta: float) -> void:
	set_screen_position()

func set_screen_position(return_position:bool = false) -> void:
	var player_pos = player_node.global_position
	var x = floor((player_pos.x) / (screen_size.x - 2*offset_size)) * (screen_size.x - 2*offset_size) + (screen_size.x - 2*offset_size)/2
	var y = floor((player_pos.y) / (screen_size.y - 2*offset_size)) * (screen_size.y - 2*offset_size) + (screen_size.y - 2*offset_size)/2
	global_position = Vector2(x,y)

func get_camera_rect_based_on_mouse():
	var mouse_pos = get_global_mouse_position()
	var x = floor((mouse_pos.x) / (screen_size.x - 2*offset_size)) * (screen_size.x - 2*offset_size) + (screen_size.x - 2*offset_size)/2
	var y = floor((mouse_pos.y) / (screen_size.y - 2*offset_size)) * (screen_size.y - 2*offset_size) + (screen_size.y - 2*offset_size)/2
	return Vector2(x,y)
	
	
