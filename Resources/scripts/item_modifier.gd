extends Resource

class_name ItemModifier

var class_type = GlobalItemsMgmt.TYPE_OF_ITEMS.ITEM_MODIFIER

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
		
@export_group("Stats Modifier")
@export var stats_modifier: StatsSheet = StatsSheet.new()


func get_stats_modifier():
	if stats_modifier is StatsSheet:
		return stats_modifier
	else:
		return StatsSheet.new()
