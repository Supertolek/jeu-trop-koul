extends Camera2D
class_name RoomCamera

@onready var screen_size: Vector2 = get_viewport_rect().size / zoom 
#@export var player_node: CharacterBody2D
var player_node: CharacterBody2D 
@export var offset_size: int = 96 
@export var time_taken = 0.5

func _ready() -> void:
	player_node = Global.players[0]
	print(player_node)
	set_screen_position()
	#Wait until next frame
	#await  get_tree().process_frame
	#position_smoothing_enabled = true
	#position_smoothing_speed = 7.0

func _process(_delta: float) -> void:
	set_screen_position()

func set_screen_position() -> void:
	var player_pos = player_node.global_position - Vector2(offset_size, offset_size)
	#var player_pos = Vector2.ZERO - Vector2(offset_size, offset_size)
	var x = floor(player_pos.x / (screen_size.x - 2*offset_size)) * (screen_size.x - 2*offset_size) + screen_size.x/2
	var y = floor(player_pos.y / (screen_size.y - 2*offset_size)) * (screen_size.y - 2*offset_size) + screen_size.y/2
	#global_position = Vector2(x,y)
	var tween = get_tree().create_tween()
	tween.tween_property(self,"global_position",Vector2(x,y),time_taken)
	
	
