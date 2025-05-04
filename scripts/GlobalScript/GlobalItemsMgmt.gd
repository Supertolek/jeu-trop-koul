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
	default_player_stats.stat_max_health = 10
	default_player_stats.stat_defense = 5
	default_player_stats.stat_attack = 10
	default_player_stats.stat_strength = 1
	default_player_stats.stat_crit_chance = 0
	default_player_stats.stat_crit_damage = 0
	default_player_stats.stat_attack_speed = 1
	default_player_stats.stat_speed = 10
