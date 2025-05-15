extends Sprite2D

func _ready() -> void:
	texture = get_parent().brands_controller_icon[get_parent().controller_brand]
