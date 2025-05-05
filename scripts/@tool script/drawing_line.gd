@tool
class_name CameraSnapPreview
extends Node2D

@export_category("Preview settings")
@export_group("Camera")
@export var room_size: Vector2 = Vector2(1152, 640) ## Size in tiles displayed
@export var source_tilemap: TileMapLayer = TileMapLayer.new()
@export var source_camera: RoomCamera = RoomCamera.new()

@export_group("Display")
@export var primary_lines: Color = Color(0, 0, 0)
@export var secondary_lines: Color
@export var middle_lines: Color
@export var show_in_game:bool = false

func _process(_delta: float) -> void:
	# Force the posistion of the node which had the tool script to be stick to the center
	if position:
		position = Vector2.ZERO
	queue_redraw()
			
		

func _draw() -> void:
	if not Engine.is_editor_hint():
		if not show_in_game:
			return
	var camera_offset := source_camera.offset_size
	var camera_offset_vect := Vector2(camera_offset,camera_offset)
	#var camera_size := room_size * source_tilemap.scale * 32 / source_camera.zoom
	#var camera_size := get_viewport_rect().size
	var camera_size := room_size
	var inside_camera_size := camera_size - 2 * camera_offset_vect
	
	var mouse_pos := get_global_mouse_position() - inside_camera_size/2 - camera_offset_vect
	var clamped_mouse_pos = round((mouse_pos)/inside_camera_size) * inside_camera_size
	
	draw_rect(Rect2(clamped_mouse_pos, camera_size), primary_lines, false, 4)
	draw_rect(Rect2(clamped_mouse_pos + camera_offset_vect, inside_camera_size), secondary_lines, false, 4)
	draw_line(
		Vector2(clamped_mouse_pos.x + inside_camera_size.x/2, clamped_mouse_pos.y) + camera_offset_vect,
		Vector2(clamped_mouse_pos.x + inside_camera_size.x/2, clamped_mouse_pos.y + inside_camera_size.y) + camera_offset_vect,
		middle_lines,
		4
	)
	draw_line(
		Vector2(clamped_mouse_pos.x, clamped_mouse_pos.y + inside_camera_size.y/2) + camera_offset_vect,
		Vector2(clamped_mouse_pos.x + inside_camera_size.x, clamped_mouse_pos.y + inside_camera_size.y/2) + camera_offset_vect,
		middle_lines,
		4
	)
