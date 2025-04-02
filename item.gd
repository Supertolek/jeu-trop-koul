extends Resource

class_name Item

@export var name: String
@export_multiline var description: String
@export var icon: Texture2D
@export var FORCE: Dictionary[Global.MODIFICATION_TYPE,int]
@export var DEFENSE: Dictionary[Global.MODIFICATION_TYPE,int]
@export var HEALTH: Dictionary[Global.MODIFICATION_TYPE,int]
