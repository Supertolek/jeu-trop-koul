@tool
extends Resource

class_name StatsSheet


var stats: Dictionary[StatsResource,float] = get_stats()

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	for category in GlobalStatsMgmt.STATS_CATEGORIES:
		properties.append({
			"name": category.capitalize() + ' Stats',
			"type": TYPE_NIL,
			"usage": PROPERTY_USAGE_GROUP,
			"hint_string": "stats",
		})
		for stat in stats:
			if stat.category == GlobalStatsMgmt.STATS_CATEGORIES[category] and !stat.is_internal:
				properties.append({
					"name": "stats_" + str(stat.display_name),
					"type": TYPE_FLOAT,
				})
	
	return properties
	
func _get(property):
	if property.begins_with("stats_"):
		var current_stat = property.get_slice("_", 1)
		for stat in stats:
			if stat.display_name == current_stat:
				return stats[stat]

func _set(property, value):
	if property.begins_with("stats_"):
		var current_stat = property.get_slice("_", 1)
		for stat in stats:
			if stat.display_name == current_stat:
				stats[stat] = value
		return true
	return false
	
func _property_can_revert(property: StringName):
	if property.begins_with("stats_"):
		var current_stat = property.get_slice("_", 1)
		for stat in stats:
			if stat.display_name == current_stat:
				match stat.add_operation:
					GlobalStatsMgmt.MATH_OPERATIONS.PLUS:
						return !0 == stats[stat]
					GlobalStatsMgmt.MATH_OPERATIONS.MULT:
						return !1 == stats[stat]

func _property_get_revert(property: StringName):
	if property.begins_with("stats_"):
		var current_stat = property.get_slice("_", 1)
		for stat in stats:
			if stat.display_name == current_stat:
				match stat.add_operation:
					GlobalStatsMgmt.MATH_OPERATIONS.PLUS:
						return 0
					GlobalStatsMgmt.MATH_OPERATIONS.MULT:
						return 1


func get_stats() -> Dictionary[StatsResource,float]:
	var baseStats_file_path = "res://Resources/Stats/BaseStats/"
	var dir = DirAccess.open(baseStats_file_path)
	var stats_dict: Dictionary[StatsResource,float] = {}
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with('.tres'):
				var stat : StatsResource = load(baseStats_file_path + file_name)
				match stat.add_operation:
					GlobalStatsMgmt.MATH_OPERATIONS.PLUS:
						stats_dict[stat] = 0
					GlobalStatsMgmt.MATH_OPERATIONS.MULT:
						stats_dict[stat] = 1
						
				#if !stat.is_internal:
					#print(stat.display_name)
					
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return stats_dict


#
#func get_stat_categories(stats_array:Array[StatsResource]) -> Array[String]:
	#var categories: Array = []
	#for stat:StatsResource in stats_array:
		#if !stat.remove_operation:
			#if !stat.category in categories:
				
				
			
