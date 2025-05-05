extends Button


class_name InventorySlot

signal slot_pressed
signal slot_released

enum  SLOT_TYPE {
	IN_INVENTORY,
	IN_PREVIEW,
}
@onready var item_texture: TextureRect = %ItemTexture

var texture:
	set(value):
		texture = value
		%ItemTexture.texture = value # item_texture isn't created yet when the scene init' because it need to wait that the scene_tree is ready and since this variable is called before the _ready we use direct path instead.
var item_type:GlobalItemsMgmt.TYPE_OF_ITEMS
@export_enum('In Inventory','In Preview') var slot_type:int = 0
var inventory_index:int
var item:
	set(value):
		item = value
		refresh_item()
		
func refresh_item():
		if item:
			item_type = item.class_type
			texture = get_item_texture()
		else:
			item_type = GlobalItemsMgmt.TYPE_OF_ITEMS.NONE
			texture = null

func get_item_texture():
	if item:
		match item_type:
			#Add new match case if the way to access data is different 
			_:
				return item.icon

func get_item_name():
	if item:
		match item_type:
			#Add new match case if the way to access data is different 
			_:
				return item.name
			
func get_item_description():
	if item:
		match item_type:
			#Add new match case if the way to access data is different 
			_:
				return item.description
			
func get_item_rarity():
	if item:
		match item_type:
			#Add new match case if the way to access data is different 
			_:
				return item.rarity

func _on_resized() -> void:
	custom_minimum_size.y = get_rect().size.x


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click"):
			if GlobalItemsMgmt.is_item(item):
				
				slot_pressed.emit(self)
		elif event.is_action_released("left_click"):
			if GlobalItemsMgmt.is_item(item):
				
				slot_released.emit(self)


func _on_mouse_entered() -> void:
	if item == null: return
	#Popups.ItemPopup(Rect2(global_position,size),item)
	pass


func _on_mouse_exited() -> void:
	#Popups.HideItemPopup()
	pass
