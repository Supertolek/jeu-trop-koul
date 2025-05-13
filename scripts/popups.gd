extends Control

# If the stat popup need to show stat that don't change (with a bonus of +0 or *1)
var display_zero: bool = false
const POPUP_STAT_LINE = preload("res://scenes/popup_stat_line.tscn")

@onready var item_popup: PanelContainer = %ItemPopup
@onready var inner_text: VBoxContainer = %InnerText
@onready var item_name: Label = %ItemName
@onready var stats_container_title: Label = %StatsContainerTitle

var in_shift:bool = false
var current_slot
var current_item
var device_id:int = 0
func _input(event: InputEvent) -> void:
	if (!(event is InputEventKey or event is InputEventMouse) and device_id == -2) or\
	 ((event is InputEventKey or event is InputEventMouse) and device_id >=0) or\
	(device_id >= 0 and event.device != device_id): return
	
	if event.is_action_pressed("shift"):
		if item_popup.visible:
			in_shift = true
			var local_current_slot = current_slot
			var local_current_item = current_item
			HideItemPopup()
			await get_tree().process_frame
			ItemPopup(local_current_slot,local_current_item)
	elif event.is_action_released("shift"):
		if item_popup.visible:
			in_shift = false
			var local_current_slot = current_slot
			var local_current_item = current_item
			HideItemPopup()
			await get_tree().process_frame
			if !local_current_item: return
			ItemPopup(local_current_slot,local_current_item)


func _process(_delta: float) -> void:
	pass
	#if Input.is_action_just_pressed("shift"):
		#if item_popup.visible:
			#in_shift = true
			#var local_current_slot = current_slot
			#var local_current_item = current_item
			#HideItemPopup()
			#await get_tree().process_frame
			#ItemPopup(local_current_slot,local_current_item)
	#elif  Input.is_action_just_released("shift"):
		#if item_popup.visible:
			#in_shift = false
			#var local_current_slot = current_slot
			#var local_current_item = current_item
			#HideItemPopup()
			#await get_tree().process_frame
			#ItemPopup(local_current_slot,local_current_item)

func ItemPopup(slot:Rect2, item):
	current_slot = slot
	current_item = item
	
	if item != null:
		set_item(item)
		item_popup.size = Vector2.ZERO # set the minimumun size for the content. NEEDED! I DON'T KNOW WHY BUT NEEDED!
	item_popup.size = Vector2.ZERO 
	
	# Tweak the display based on if the player want to see the item base stats or not
	if in_shift:
		if item is Weapon or item is Armor:
			stats_container_title.text = "Base Stats:"
		else:
			stats_container_title.text = "Stats:"
	else:
		stats_container_title.text = "Stats:"
		
	# Some Calculation for displaying correctly the popup beside the slot
	var mouse_pos: Vector2
	if device_id == -2:
		mouse_pos = get_viewport().get_mouse_position()
	else:
		mouse_pos = slot.get_center()
	var padding: int = 15
	var correction: Vector2 = Vector2.ZERO
	
	if mouse_pos.x <= get_viewport_rect().size.x/2:
		correction += Vector2(slot.size.x + padding,0)
	else:
		correction += -Vector2(item_popup.size.x + padding, 0)
	correction += -Vector2(0,item_popup.size.y/2)
	
	item_popup.global_position = slot.position + correction
	
	for stat in inner_text.get_children():
		if stat.name == 'Name': continue
		var custom_minimum_size_x: int = 0
		var custom_minimum_size_y: int = 0
		for label in stat.get_children():
			custom_minimum_size_x += label.size.x
			custom_minimum_size_y = max(custom_minimum_size_y,label.size.y)
		stat.custom_minimum_size = Vector2(custom_minimum_size_x,custom_minimum_size_y) 

	# Finally show the popup
	item_popup.show()

func HideItemPopup():
	for child in inner_text.get_children():
		if child is PopupStatLine:
			child.queue_free() # Remove all PopupStatLine of the Popup
			
	#Reinitialise the Popup for later use
	item_popup.hide()
	current_slot = null
	current_item = null
	
func set_item(item):
	item_name.text = item.name
	
	var item_stats: Dictionary[StatsResource,float]
	var item_stats_without_modifiers: Dictionary[StatsResource,float]
	
	# Stats calculation in order to render them later
	if item is Weapon or item is Armor:
		item_stats = item.calculate_stats().stats
		if in_shift:
			item_stats_without_modifiers = item.base_stats.stats
	elif item is ItemModifier:
		item_stats = item.get_stats_modifier().stats
	else:
		return # The given item isn't supported yet
	
	for stat: StatsResource in item_stats:
		var stat_value: float = item_stats[stat]
		if !display_zero and ((stat_value == 0 and stat.add_operation == GlobalItemsMgmt.MATH_OPERATIONS.PLUS) or (stat_value == 1 and stat.add_operation == GlobalItemsMgmt.MATH_OPERATIONS.MULT)):
			continue
		if stat.is_internal:
			continue
			
		var new_stat_line : PopupStatLine= POPUP_STAT_LINE.instantiate()
		inner_text.add_child(new_stat_line)
		if item_stats_without_modifiers:
			new_stat_line.create(stat.display_name, stat_value, stat.add_operation, item_stats_without_modifiers[stat])
		else:
			new_stat_line.create(stat.display_name, stat_value, stat.add_operation)
