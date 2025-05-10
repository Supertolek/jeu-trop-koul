extends Node


enum STATS_CATEGORIES {
	HEALTH,
	ATTACK,
	SPELL,
	MISC,
}

enum MATH_OPERATIONS {
	PLUS,
	MINUS,
	MULT,
	DIV,
	MAX,
	MIN,
	LIST_APPEND,
	LIST_REMOVE,
	}

enum ITEMS_RARITY{COMMON, UNCOMMON, RARE, EPIC, LEGENDARY, MYTHIC,}

enum TYPE_OF_ITEMS {
	NONE,
	STATS_RESOURCE,
	STATS_SHEET,
	WEAPON,
	ARMOR,
	ITEM_MODIFIER,
}

const STATS_COLOR: Dictionary = {"positive":"75F94C","negative":"EB3223","null":"FFFFFF"}

func is_item(item):
	if !item: return false
	match item.class_type:
		TYPE_OF_ITEMS.NONE:
			return false
		TYPE_OF_ITEMS.STATS_SHEET:
			return false
		TYPE_OF_ITEMS.WEAPON:
			return true
		TYPE_OF_ITEMS.ARMOR:
			return true
		TYPE_OF_ITEMS.ITEM_MODIFIER:
			return true
		_:
			return false

func display_stats_sheet(statssheet:StatsSheet):
	for stat in statssheet.stats:
		print(stat.display_name + ' -> ' + str(statssheet.stats[stat]))

func merge_stats_sheet(first_SS:StatsSheet, second_SS:StatsSheet, display_in_console:bool = false):
	var merged_SS: StatsSheet = StatsSheet.new()
	for stat in merged_SS.get_stats():
		var stat_name: String = stat.get_file_name()
		var operation: MATH_OPERATIONS = stat.add_operation
		match operation:
			MATH_OPERATIONS.PLUS:
				if second_SS[stat_name] != 0:
					if display_in_console: print(stat.display_name + ' '.repeat(26-len(stat_name)) + ': ' + str(first_SS[stat_name]) + ' '.repeat(6-len(str(first_SS[stat_name]))) + '+ ' +  str(second_SS[stat_name]) + ' '.repeat(6-len(str(second_SS[stat_name]))) + ' = ' + str(first_SS[stat_name] + second_SS[stat_name]))
					merged_SS[stat_name] = first_SS[stat_name] + second_SS[stat_name]
				else:
					merged_SS[stat_name] = first_SS[stat_name]
			MATH_OPERATIONS.MULT:
				if second_SS[stat_name] > 0: 
					if second_SS[stat_name] != 1:
						if display_in_console: print(stat.display_name + ' '.repeat(26-len(stat_name)) + ': ' + str(first_SS[stat_name]) + ' '.repeat(6-len(str(first_SS[stat_name]))) + '* ' +  str(second_SS[stat_name]) + ' '.repeat(6-len(str(second_SS[stat_name]))) + ' = ' + str(first_SS[stat_name] * second_SS[stat_name]))
						merged_SS[stat_name] = first_SS[stat_name] * second_SS[stat_name]
					else:
						merged_SS[stat_name] = first_SS[stat_name]
	if display_in_console: print()
	return merged_SS
	
	

var default_player_stats: StatsSheet = StatsSheet.new()
func _ready() -> void:
	default_player_stats.stat_max_health = 20
	default_player_stats.stat_defense = 0
	default_player_stats.stat_health_regeneration = 1  # 0 signifie aucune régénération 
	default_player_stats.stat_attack = 1
	default_player_stats.stat_strength = 1
	default_player_stats.stat_crit_chance = 0
	default_player_stats.stat_crit_damage = 0
	default_player_stats.stat_attack_speed = 1
	default_player_stats.stat_speed = 10

func calculate_crit_damage(player_stats_sheet:StatsSheet):
	var crit_chance = clamp(player_stats_sheet.stat_crit_chance,0,100)
	var crit_damage = clamp(player_stats_sheet.stat_crit_damage,0,400)
	if randi_range(0,99) < crit_chance:
		return 1+(crit_damage/100)
	else:
		return 1

func calculate_damage(player_stats_sheet:StatsSheet) -> float:
	var attack = clamp(player_stats_sheet.stat_attack,1,100)
	var strength = clamp(player_stats_sheet.stat_strength,0.05,10)
	return attack * strength * calculate_crit_damage(player_stats_sheet)
