@tool
class_name CameraSnapPreview
extends Node2D

@export_category("Preview settings")
@export_group("Camera")
@export var room_size: Vector2 = Vector2(36, 20) ## Size in tiles displayed
@export var source_tilemap: TileMapLayer = TileMapLayer.new()
@export var source_camera: RoomCamera = RoomCamera.new()

@export_group("Display")
@export var primary_lines: Color = Color(0, 0, 0)
@export var secondary_lines: Color
@export var rooms_around: int = 2



func _process(delta: float) -> void:
	# Force the posistion of the node which had the tool script to be stick to the center
	if position:
		position = Vector2.ZERO
	queue_redraw()

func _draw() -> void:
	var camera_offset := source_camera.offset_size
	var camera_offset_vect := Vector2(camera_offset,camera_offset)
	var camera_size := room_size * source_tilemap.scale * 32 / source_camera.zoom
	var inside_camera_size := camera_size - 2* camera_offset_vect
	
	var mouse_pos := get_global_mouse_position() - camera_size/2
	var clamped_mouse_pos = round((mouse_pos)/inside_camera_size) * inside_camera_size
	
	draw_rect(Rect2(clamped_mouse_pos, camera_size), primary_lines, false)
	draw_rect(Rect2(clamped_mouse_pos + camera_offset_vect , inside_camera_size), secondary_lines, false)
