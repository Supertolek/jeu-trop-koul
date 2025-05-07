@tool
extends StaticBody2D

class_name SpikeObjects


@export var spike_enabled_default: bool = false:
	set(value):
		if value:
			enable_spike()
		else:
			disable_spike()
		spike_enabled_default = value

@export_group('Internal')
@export_tool_button("Enable") var open_button = enable_spike
@export_tool_button("Disable") var close_button = disable_spike

@onready var spike: Sprite2D = %spike
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var enable: bool = spike_enabled_default



func enable_spike():
	if enable: return
	animation_player.play('enable')
	spike_enabled_default = true
	enable = true
				
		
func disable_spike():
	if !enable: return
	animation_player.play('disable')
	spike_enabled_default = false
	enable = false
		
