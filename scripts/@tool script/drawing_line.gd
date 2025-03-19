@tool
class_name CameraSnapPreview
extends Node2D

@export_category("Preview settings")
@export_group("Camera")
@export var room_size: Vector2i = Vector2i(36, 20) ## Size in tiles displayed
@export var source_tilemap: TileMapLayer = TileMapLayer.new()

@export_group("Display")
@export var primary_lines: Color = Color(0, 0, 0)
@export var secondary_lines: Color
@export var rooms_around: int = 2

var editor_settings: EditorSettings = EditorInterface.get_editor_settings()

func _process(delta: float) -> void:
	if position:
		position = Vector2.ZERO
	queue_redraw()

func _draw() -> void:
	var camera_size := Vector2(room_size) * source_tilemap.scale * 32
	
	var mouse_pos := get_global_mouse_position()
	var clamped_mouse_pos = round(mouse_pos/camera_size) * camera_size
	
	draw_rect(Rect2(clamped_mouse_pos - camera_size/2, camera_size), editor_settings.get_setting("interface/theme/accent_color"), false)
