extends Control

@export var players: Array[Player]:
	set(value):
		players = value
		if value and get_window():
			place_viewports()

func place_viewport_at(relative_position: Vector2, relative_size: float, player: Player):
	# Create viewport object
	var viewport_to_place := SubViewport.new()
	var viewport_container := SubViewportContainer.new()
	viewport_container.add_child(viewport_to_place)
	add_child(viewport_container)
	# Place viewport
	var current_viewport_rect := get_window().get_viewport().get_visible_rect()
	#1152 × 640
	var desired_size := current_viewport_rect.size * relative_size
	viewport_to_place.size = desired_size
	viewport_container.size = current_viewport_rect.size
	viewport_container.scale = Vector2(relative_size, relative_size)
	viewport_container.position = current_viewport_rect.size * relative_position - viewport_container.size/4
	viewport_container.stretch = true
	viewport_to_place.handle_input_locally = false
	viewport_to_place.world_2d = get_window().world_2d
	# Link to player's camera
	#player.get_camera().effective_zoom = player.get_camera().zoom
	#player.get_camera().visual_zoom = Vector2(relative_size, relative_size)
	player.get_camera().custom_viewport = viewport_to_place
	player.get_camera().make_current()

func place_viewports(force: bool = false):
	var childrens := get_children()
	# Check if the reload is needed
	if len(childrens) != len(players) or force:
		# Remove the viewports
		for child in childrens:
			if child is SubViewportContainer:
				child.queue_free()
		# Place the viewports
		var player_count = len(players)
		match player_count:
			1:
				place_viewport_at(Vector2(0.5, 0.5), 1, players[0])
			2:
				place_viewport_at(Vector2(0.25, 0.5), 0.5, players[0])
				place_viewport_at(Vector2(0.75, 0.5), 0.5, players[1])
			3:
				place_viewport_at(Vector2(0.25, 0.25), 0.5, players[0])
				place_viewport_at(Vector2(0.75, 0.25), 0.5, players[1])
				place_viewport_at(Vector2(0.5, 0.75), 0.5, players[2])
			4:
				place_viewport_at(Vector2(0.25, 0.25), 0.5, players[0])
				place_viewport_at(Vector2(0.75, 0.25), 0.5, players[1])
				place_viewport_at(Vector2(0.25, 0.75), 0.5, players[2])
				place_viewport_at(Vector2(0.75, 0.75), 0.5, players[3])

func _ready() -> void:
	place_viewports(true)
