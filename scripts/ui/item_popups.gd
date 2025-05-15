extends PanelContainer

class_name ItemPopups

var display_zero: bool = true
const POPUP_STAT_LINE = preload("res://scenes/popup_stat_line.tscn")

@onready var inner_text: VBoxContainer = %InnerText
@onready var item_name: Label = %ItemName
@onready var stats_container: Label = %StatsContainer
@onready var inventory_ui: InventoryUI = owner

var in_shift:bool = false
var current_slot: InventorySlot

var device_id:int


func _input(event: InputEvent) -> void:
	if (!(event is InputEventKey or event is InputEventMouse) and device_id == -2) or\
	 ((event is InputEventKey or event is InputEventMouse) and device_id >=0) or\
	(device_id >= 0 and event.device != device_id): return

	if event.is_action_pressed("shift"):
		if visible:
			in_shift = true
			var local_current_slot = current_slot
			HideItemPopup()
			await get_tree().process_frame
			ItemPopup(local_current_slot)
	elif event.is_action_released("shift"):
		if visible:
			in_shift = false
			var local_current_slot = current_slot
			HideItemPopup()
			await get_tree().process_frame
			ItemPopup(local_current_slot)
			

func ItemPopup(slot:InventorySlot):
	if !slot: return
	show()
	
	var slot_position: Vector2 = slot.get_global_transform_with_canvas().get_origin()
	var padding: int = 15
	var correction: Vector2 = Vector2.ZERO
	
	if slot_position.x <= inventory_ui.size.x/2:
		correction += Vector2(slot.size.x + padding, 0)
	else:
		correction += -Vector2(size.x + padding, 0)
	#correction += -Vector2(0, size.y/2)
	
	global_position = slot_position + correction
	
func HideItemPopup():
	hide()
