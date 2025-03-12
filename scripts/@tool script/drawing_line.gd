@tool
extends Node2D
@export_category('Drawing Line')
@export_group('Link')
@export var camera_scene: RoomCamera
@export var tilemaplayer_node: Array[TileMapLayer]

@export_group('Display')
@export var display_line: bool = false

@export var main_rect_color: Color = Color("000000")
@export var secondary_rect_color: Color = Color("5b5b5b")

@export_range(0,20,0.1,'or_greater') var main_rect_width: float = 10
@export_range(0,20,0.1,'or_greater') var secondary_rect_width: float = 5




func _process(delta: float) -> void:
	if position:
		position = Vector2.ZERO
	queue_redraw()


func get_camera_center_based_on_mouse_global_pos():
	var offset_size = camera_scene.offset_size
	var screen_size = Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height"),
	)
	var mouse_pos = get_global_mouse_position()
	var x = floor((mouse_pos.x) / (screen_size.x - 2*offset_size)) * (screen_size.x - 2*offset_size) + (screen_size.x - 2*offset_size)/2
	var y = floor((mouse_pos.y) / (screen_size.y - 2*offset_size)) * (screen_size.y - 2*offset_size) + (screen_size.y - 2*offset_size)/2
	return Vector2(x,y)
	

func _draw() -> void:
	
	if camera_scene and display_line:
		var offset_size = camera_scene.offset_size
		var screen_center: Vector2 = get_camera_center_based_on_mouse_global_pos()
		var screen_size = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height"),
		)
		for i in [
			Vector2(-1,-1),Vector2(0,-1),Vector2(1,-1),
			Vector2(-1,0),Vector2(1,0),
			Vector2(-1,1),Vector2(0,1),Vector2(1,1),
			Vector2(0,0),
		]:
			var screen_rect_center: Vector2 = Vector2(screen_center.x + i.x * screen_size.x - 2 * i.x * offset_size, screen_center.y + i.y * screen_size.y - 2 * i.y * offset_size)
			var points:PackedVector2Array = PackedVector2Array([
				Vector2(screen_rect_center.x + (screen_size.x - 2*offset_size)/2,screen_rect_center.y + (screen_size.y - 2*offset_size)/2),
				Vector2(screen_rect_center.x - (screen_size.x - 2*offset_size)/2,screen_rect_center.y + (screen_size.y - 2*offset_size)/2),
				Vector2(screen_rect_center.x - (screen_size.x - 2*offset_size)/2,screen_rect_center.y - (screen_size.y - 2*offset_size)/2),
				Vector2(screen_rect_center.x + (screen_size.x - 2*offset_size)/2,screen_rect_center.y - (screen_size.y - 2*offset_size)/2),
				Vector2(screen_rect_center.x + (screen_size.x - 2*offset_size)/2,screen_rect_center.y + (screen_size.y - 2*offset_size)/2)
			])
			var color: Color 
			var width: float
			if i == Vector2(0,0):
				width = main_rect_width
				color = main_rect_color
			else: 
				width = secondary_rect_width
				color = secondary_rect_color
		
		
			draw_polyline(points,color,width)
	
