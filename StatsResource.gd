extends Resource

class_name StatsResource
#@export_placeholder('In snake case') var stat_name: String 
@export var display_name: String 
@export var texture: Texture2D
@export_multiline var description: String
@export var category: GlobalStatsMgmt.STATS_CATEGORIES
@export var add_operation: GlobalStatsMgmt.MATH_OPERATIONS = GlobalStatsMgmt.MATH_OPERATIONS.PLUS
@export var remove_operation: GlobalStatsMgmt.MATH_OPERATIONS  = GlobalStatsMgmt.MATH_OPERATIONS.MINUS
@export var is_internal:bool = false
