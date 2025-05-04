extends Resource

class_name StatsResource

var class_type = GlobalItemsMgmt.TYPE_OF_ITEMS.STATS_RESOURCE

#@export_placeholder('In snake case') var stat_name: String 
@export var display_name: String 
@export var texture: Texture2D
@export_multiline var description: String
@export var category: GlobalItemsMgmt.STATS_CATEGORIES
@export var add_operation: GlobalItemsMgmt.MATH_OPERATIONS = GlobalItemsMgmt.MATH_OPERATIONS.PLUS
@export var remove_operation: GlobalItemsMgmt.MATH_OPERATIONS  = GlobalItemsMgmt.MATH_OPERATIONS.MINUS
@export var is_internal:bool = false

func get_file_name() -> String:
	return resource_path.split("/")[-1].replace(".tres","")
