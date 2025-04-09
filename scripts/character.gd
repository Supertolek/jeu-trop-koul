class_name Character
extends CharacterBody2D

var player_scale: int = 4
var character_sprite : Sprite2D
var character_collision : CollisionShape2D
@export var character_texture : Texture2D = load("res://assets/placeholders/blue_circle.png"): 
	get:
		return character_texture
	set(value):
		character_texture = value
		if character_sprite:
			character_sprite.texture = value
@export var character_collision_shape : Shape2D = RectangleShape2D.new():
	get:
		return character_collision_shape
	set(value):
		character_collision_shape = value
		if character_collision:
			character_collision.shape = value
@export var health : float

func _ready():
	character_sprite = Sprite2D.new()
	character_sprite.texture = character_texture
	add_child(character_sprite)
	character_collision = CollisionShape2D.new()
	character_collision.shape = character_collision_shape
	add_child(character_collision)
