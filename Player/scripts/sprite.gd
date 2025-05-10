extends Sprite2D


@onready var sprite_reflexion: Sprite2D = %SpriteReflexion

func _set(property: StringName, value: Variant) -> bool:
	if property == "frame":
		frame = value
		sprite_reflexion.frame = value
		return true
	return false
