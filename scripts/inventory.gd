extends Control

class_name InventoryUI

var inventory_data: Dictionary = {
	"equiped_weapon": null,
	"equiped_armor": null,
	"current_item": null,
	"inventory": [
		preload("res://Resources/Items/Items_Modifiers/ham.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/attack_of_some.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/bread.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/attack_of_some.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/attack_of_some.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/ham.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/bread.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/bread.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/ham.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/attack_of_some.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/pile_of_coin.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/ham.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/attack_of_some.tres").duplicate(),
		preload("res://Resources/Items/Items_Modifiers/bread.tres").duplicate(),
		preload("res://Resources/Items/Armor/a_cool_chestplate.tres").duplicate(),
		preload("res://Resources/Items/Weapon/test_sword.tres").duplicate(),
	]
}

@onready var inventorySlot: PackedScene = preload("res://scenes/inventory_slot.tscn")
@onready var scene_is_ready = true
var inventory_tab_index: int = 0


@onready var modified_item_name: RichTextLabel = %ModifiedItemName
@onready var modified_item_description: RichTextLabel = %ModifiedItemDescription
@onready var modified_item_inventory_slot: InventorySlot = %ModifiedItemInventorySlot
@onready var item_forge_item_modifier_tab_container: TabContainer = %ItemForgeItemModifierTabContainer
@onready var first_item_modifier_inventory_slot: InventorySlot = %FirstItemModifierInventorySlot
@onready var second_item_modifier_inventory_slot: InventorySlot = %SecondItemModifierInventorySlot
@onready var third_item_modifier_inventory_slot: InventorySlot = %ThirdItemModifierInventorySlot

@onready var equiped_armor_container: Control = %EquipedArmorContainer
@onready var equiped_armor_inventory_slot: InventorySlot = %EquipedArmorSlot
@onready var equiped_weapon_container: Control = %EquipedWeaponContainer
@onready var equiped_weapon_inventory_slot: InventorySlot = %EquipedWeaponSlot

@onready var category_tab_container: HBoxContainer = %CategoryTabContainer
@onready var inventory_scroll_container: ScrollContainer = %InventoryScrollContainer
@onready var tab_container: TabContainer = %TabContainer
@onready var all_items_inventory_container: GridContainer = %AllItemsInventoryContainer
@onready var weapon_inventory_container: GridContainer = %WeaponInventoryContainer
@onready var armor_inventory_container: GridContainer = %ArmorInventoryContainer
@onready var item_modifier_inventory_container: GridContainer = %ItemModifierInventoryContainer

@onready var dragged_item_texture_rect: TextureRect = %DraggedItem


func _ready() -> void:
	display_items()
	#update_inventory_tabContainer()
	#_resize_TabContainer()
	
	modified_item_inventory_slot.slot_pressed.connect(start_dragging)
	modified_item_inventory_slot.slot_released.connect(stop_dragging)
	first_item_modifier_inventory_slot.slot_pressed.connect(start_dragging)
	first_item_modifier_inventory_slot.slot_released.connect(stop_dragging)
	second_item_modifier_inventory_slot.slot_pressed.connect(start_dragging)
	second_item_modifier_inventory_slot.slot_released.connect(stop_dragging)
	third_item_modifier_inventory_slot.slot_pressed.connect(start_dragging)
	third_item_modifier_inventory_slot.slot_released.connect(stop_dragging)
	equiped_armor_inventory_slot.slot_pressed.connect(start_dragging)
	equiped_armor_inventory_slot.slot_released.connect(stop_dragging)
	equiped_weapon_inventory_slot.slot_pressed.connect(start_dragging)
	equiped_weapon_inventory_slot.slot_released.connect(stop_dragging)

func _process(_delta: float) -> void:
	# Dragging item system
	if is_dragging:
		dragged_item_texture_rect.global_position = get_global_mouse_position()-dragged_item_texture_rect.size/2

# DRAGGING ITEM SYSTEM


@onready var dragging_colliders: Array[Control] = [
	tab_container,
	modified_item_inventory_slot,
	first_item_modifier_inventory_slot,
	second_item_modifier_inventory_slot,
	third_item_modifier_inventory_slot,
	equiped_armor_inventory_slot,
	equiped_weapon_inventory_slot,
]
func get_dragging_collider():
	for collider in dragging_colliders:
		var collider_rect: Rect2 = Rect2(collider.global_position, collider.size)
		if collider_rect.has_point(get_global_mouse_position()):
			return collider

var is_dragging: bool = false
var dragged_item = null
var dragged_slot = null


func start_dragging(slot: InventorySlot):
	dragged_slot = slot
	dragged_item = slot.item
	dragged_item_texture_rect.visible = true
	dragged_item_texture_rect.size = slot.item_texture.size
	dragged_item_texture_rect.texture = slot.item_texture.texture
	is_dragging = true
	
func stop_dragging(initial_slot: InventorySlot):
	dragged_item_texture_rect.visible = false
	is_dragging = false
	dragged_item = null
	dragged_slot = null
	
	

func _input(_event:InputEvent) -> void:
	
	# Inventory Container Managment
	var menu_dir = int(Input.get_axis("move_ui_left","move_ui_right"))
	if Input.is_action_just_pressed("move_ui_left") or Input.is_action_just_pressed("move_ui_right"):
		inventory_tab_index = posmod(inventory_tab_index + menu_dir, category_tab_container.get_child_count())
		update_inventory_tabContainer()

func _on_all_item_category_button_pressed() -> void:
	inventory_tab_index = 0
	update_inventory_tabContainer()

func _on_weapon_item_category_button_pressed() -> void:
	inventory_tab_index = 1
	update_inventory_tabContainer()

func _on_armor_item_category_button_pressed() -> void:
	inventory_tab_index = 2
	update_inventory_tabContainer()

func _on_item_modifier_item_category_button_pressed() -> void:
	inventory_tab_index = 3
	update_inventory_tabContainer()
	
func update_inventory_tabContainer():
	# Set the current tab to the value stored internaly
	tab_container.current_tab = inventory_tab_index
	
	# For each Category button, set the alpha to 0.25 except for the selected one.
	for child: Button in category_tab_container.get_children():
		child.modulate.a = 0.25
	category_tab_container.get_child(inventory_tab_index).modulate.a = 1

enum TAB_CONTAINER_PARTS {
	ALL_ITEMS,
	WEAPON,
	ARMOR,
	ITEM_MODIFIER,
}
func display_items():
	for inventory_container_index in tab_container.get_child_count(): # Iterate througth the child of tab container as index starting at 0.
		var targeted_container = tab_container.get_child(inventory_container_index)
		# Erease all inventory slot from all previous container.
		for old_item_slot in targeted_container.get_children():
			old_item_slot.queue_free()
		
		# For each category conatiner, create and add new Inventory Slot to it. Then connect basic signal for dragging.
		match inventory_container_index:
			TAB_CONTAINER_PARTS.ALL_ITEMS:
				for item_index in inventory_data['inventory'].size():
					var item_slot: InventorySlot = inventorySlot.instantiate()
					item_slot.item = inventory_data['inventory'][item_index]
					#item_slot.inventory_index = item_index
					
					item_slot.slot_pressed.connect(start_dragging)
					item_slot.slot_released.connect(stop_dragging)
					targeted_container.add_child(item_slot)
				
			TAB_CONTAINER_PARTS.WEAPON:
				for item_index in inventory_data['inventory'].size():
					var item = inventory_data['inventory'][item_index]
					if item.class_type == GlobalItemsMgmt.TYPE_OF_ITEMS.WEAPON:
						var item_slot: InventorySlot = inventorySlot.instantiate()
						item_slot.item = item
						#item_slot.inventory_index = item_index
						
						item_slot.slot_pressed.connect(start_dragging)
						item_slot.slot_released.connect(stop_dragging)
						targeted_container.add_child(item_slot)
						
			TAB_CONTAINER_PARTS.ARMOR:
				for item_index in inventory_data['inventory'].size():
					var item = inventory_data['inventory'][item_index]
					if item.class_type == GlobalItemsMgmt.TYPE_OF_ITEMS.ARMOR:
						var item_slot: InventorySlot = inventorySlot.instantiate()
						item_slot.item = item
						#item_slot.inventory_index = item_index
						
						item_slot.slot_pressed.connect(start_dragging)
						item_slot.slot_released.connect(stop_dragging)
						targeted_container.add_child(item_slot)
						
			TAB_CONTAINER_PARTS.ITEM_MODIFIER:
				for item_index in inventory_data['inventory'].size():
					var item = inventory_data['inventory'][item_index]
					if item.class_type == GlobalItemsMgmt.TYPE_OF_ITEMS.ITEM_MODIFIER:
						var item_slot: InventorySlot = inventorySlot.instantiate()
						item_slot.item = item
						#item_slot.inventory_index = item_index
						
						item_slot.slot_pressed.connect(start_dragging)
						item_slot.slot_released.connect(stop_dragging)
						targeted_container.add_child(item_slot)
