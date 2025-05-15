extends Sprite2D


@onready var sprite_reflexion: Sprite2D = %SpriteReflexion

func set_sprite_texture(_texture: Texture2D) -> void:
	texture = _texture
	sprite_reflexion.texture = _texture

func _set(property: StringName, value: Variant) -> bool:
	if property == "frame":
		frame = value
		sprite_reflexion.frame = value
		return true
	return false
