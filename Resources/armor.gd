extends Resource

class_name Armor

var class_type = GlobalItemsMgmt.TYPE_OF_ITEMS.ARMOR
var weapon_stats: StatsSheet = StatsSheet.new()

@export_group("Display")
@export var name : String:
	set(value):
		name = value
		
@export var icon : Texture2D:
	set(value):
		icon = value
		
@export var rarity : GlobalItemsMgmt.ITEMS_RARITY:
	set(value):
		rarity = value
		
@export_multiline var description: String:
	set(value):
		description = value


@export_group("Modifiers")
@export var base_stats: StatsSheet = StatsSheet.new()
@export var first_item_modifier: ItemModifier
@export var second_item_modifier: ItemModifier
@export var third_item_modifier: ItemModifier

func get_item_modifiers(fill:bool=false) -> Array[ItemModifier]:
	var item_modifiers: Array[ItemModifier] = []
	for property in get_property_list():
		if property['name'].ends_with('_item_modifier'):
			var item_modifier = get(property['name'])
			if item_modifier:
				item_modifiers.append(item_modifier)
			elif fill:
				item_modifiers.append(null)
				
	return item_modifiers


func calculate_stats(display_in_console:bool = false):
	var calculated_stats: StatsSheet = StatsSheet.new()
	if display_in_console: print('Base stats:')
	calculated_stats = GlobalItemsMgmt.merge_stats_sheet(calculated_stats, base_stats, display_in_console)
	for item_modifier in get_item_modifiers():
		if display_in_console: print(item_modifier.name)
		calculated_stats = GlobalItemsMgmt.merge_stats_sheet(calculated_stats, item_modifier.stats_modifier, display_in_console)
	
	if display_in_console: print('Summarizing: ' + self.name.to_upper())
	weapon_stats = calculated_stats
	return calculated_stats
