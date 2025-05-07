@tool
extends Resource

class_name StatsSheet

var class_type = GlobalItemsMgmt.TYPE_OF_ITEMS.STATS_SHEET

var stats: Dictionary[StatsResource,float] = get_stats()

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	for category in GlobalItemsMgmt.STATS_CATEGORIES:
		properties.append({
			"name": category.capitalize() + ' Stats',
			"type": TYPE_NIL,
			"usage": PROPERTY_USAGE_GROUP,
			"hint_string": "stat",
		})
		for stat in stats:
			if stat.category == GlobalItemsMgmt.STATS_CATEGORIES[category] and !stat.is_internal:
				properties.append({
					"name": get_stat_file_name(stat),
					"type": TYPE_FLOAT,
				})
	
	return properties
	
func _get(property):
	if property.begins_with("stat_"):
		var current_stat = property
		for stat in stats:
			if get_stat_file_name(stat) == current_stat:
				return stats[stat]

func _set(property, value):
	if property.begins_with("stat_"):
		var current_stat = property
		for stat in stats:
			if get_stat_file_name(stat) == current_stat:
				stats[stat] = value
		return true
		
	return false

func _property_can_revert(property: StringName):
	if property.begins_with("stat_"):
		var current_stat = property
		for stat in stats:
			if get_stat_file_name(stat) == current_stat:
				match stat.add_operation:
					GlobalItemsMgmt.MATH_OPERATIONS.PLUS:
						return !0 == stats[stat]
					GlobalItemsMgmt.MATH_OPERATIONS.MULT:
						return !1 == stats[stat]

func _property_get_revert(property: StringName):
	if property.begins_with("stat_"):
		var current_stat = property
		for stat in stats:
			if get_stat_file_name(stat) == current_stat:
				match stat.add_operation:
					GlobalItemsMgmt.MATH_OPERATIONS.PLUS:
						return 0
					GlobalItemsMgmt.MATH_OPERATIONS.MULT:
						return 1


func get_stats() -> Dictionary[StatsResource,float]:
	if stats: return stats
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
					GlobalItemsMgmt.MATH_OPERATIONS.PLUS:
						stats_dict[stat] = 0
					GlobalItemsMgmt.MATH_OPERATIONS.MULT:
						stats_dict[stat] = 1
						
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return stats_dict
func get_stat_file_name(stat_resource:StatsResource) -> String:
	return stat_resource.resource_path.split("/")[-1].replace(".tres","")
