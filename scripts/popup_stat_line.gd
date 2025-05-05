extends HBoxContainer

class_name PopupStatLine

@onready var stat_name: Label = %StatName
@onready var stat_value: Label = %StatValue

func create(_stat_name:String, _stat_value, add_operation: GlobalItemsMgmt.MATH_OPERATIONS, item_stats_without_modifiers = null) -> void:
	# When the player want to see the item stat without it's Items Modifier
	if item_stats_without_modifiers != null:
		_stat_value = item_stats_without_modifiers
	
	# Display the stat name 
	stat_name.text = _stat_name + ":"
	
	# Display the stat value with a variation depending of the add_operation of the stat.
	var stat_value_str: String = str(_stat_value)
	if _stat_value > 0 and add_operation == GlobalItemsMgmt.MATH_OPERATIONS.PLUS:
		stat_value_str = '+' + str(_stat_value)
	elif _stat_value > 0 and add_operation == GlobalItemsMgmt.MATH_OPERATIONS.MULT:
		stat_value_str = '*' + str(_stat_value)
	stat_value.text = stat_value_str
	
	# Finally tweak the color of the line based on if the stat's value is positive or negative
	if (_stat_value < 0 and add_operation == GlobalItemsMgmt.MATH_OPERATIONS.PLUS) or (_stat_value < 1 and add_operation == GlobalItemsMgmt.MATH_OPERATIONS.MULT):
		modulate = GlobalItemsMgmt.STATS_COLOR['negative']
	elif (_stat_value > 0 and add_operation == GlobalItemsMgmt.MATH_OPERATIONS.PLUS) or (_stat_value > 1 and add_operation == GlobalItemsMgmt.MATH_OPERATIONS.MULT):
		modulate = GlobalItemsMgmt.STATS_COLOR['positive']
	else:
		modulate = GlobalItemsMgmt.STATS_COLOR['null']
