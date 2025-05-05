extends Control

class_name InventoryUI
var a: Dictionary

var inventory_data: Dictionary = {
	"equiped_weapon": null,
	"equiped_armor": null,
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
@onready var item_forge_item_modifier_h_container: HBoxContainer = %ItemForgeItemModifierHContainer
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

func display_ui(_inventory_data):
	visible = true
	# Transfer data from the player's inventory_data to the actual inventory control's inventory_data 
	inventory_data = _inventory_data
	equiped_armor_inventory_slot.item = inventory_data['equiped_armor']
	equiped_weapon_inventory_slot.item = inventory_data['equiped_weapon']
	display_items()
	update_inventory_tabContainer()

func hide_ui():
	visible = false
	# If there is an item in the forge when the inventory is closed, this item get remove from the forge and added to the inventory
	if modified_item_inventory_slot.item:
		inventory_data['inventory'].append(modified_item_inventory_slot.item)
	reset_forge_modified_item()
	return inventory_data



# DRAGGING ITEM SYSTEM


@onready var dragging_colliders: Array = [
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
	# La façon dont cette fonction marche est la suivante:
	
	# Tout d'abord, on récupère sur quel collider l'objet a été laché  
	var collider = get_dragging_collider()
	# Et puis on éxécute un programme différent en fonction de où l'objet a été laché. 
	match dragging_colliders.find(collider):
		0: # Si l'objet est laché sur le tab_container
			if !dragged_item in inventory_data['inventory']: # Alors on vérifie que l'objet ne se trouve pas dans l'aventaire avant de l'ajouter.
				# Maintenant on veux éfféctuer des actions différentes en fonction de où vient l'item.
				match dragging_colliders.find(initial_slot):
					1: # Si il vient de modified_item_inventory_slot
						inventory_data['inventory'].append(dragged_item) # On ajoute d'abord l'item à l'inventaire
						display_items() # Et on réaffiche les items 
						reset_forge_modified_item() # Finalement on le retire de la forge.
						
					# Le fonctionement des 3 item_modifier est le meme pour chacun.
					2: #Si l'objet vient de first_item_modifier_slot
						modified_item_inventory_slot.item.first_item_modifier = null # On enlève le premier item_modifier de l'item forgé.
						set_forge_modified_item(modified_item_inventory_slot) # On reactualise l'item forgé afin que le premier item_modifier disparaisse de l'affichage
						
						inventory_data['inventory'].append(dragged_item) # On ajoute cet item_modifier à l'inventaire
						display_items() # Et on réaffiche les items de l'inventaire
						
					3: #Si l'objet vient de second_item_modifier_inventory_slot
						modified_item_inventory_slot.item.second_item_modifier = null # On enlève le second item_modifier de l'item forgé.
						set_forge_modified_item(modified_item_inventory_slot) # On reactualise l'item forgé afin que le second item_modifier disparaisse de l'affichage
						
						inventory_data['inventory'].append(dragged_item) # On ajoute cet item_modifier à l'inventaire
						display_items() # Et on réaffiche les items de l'inventaire
						
					4: #Si l'objet vient de third_item_modifier_inventory_slot
						modified_item_inventory_slot.item.third_item_modifier = null # On enlève le troisième item_modifier de l'item forgé.
						set_forge_modified_item(modified_item_inventory_slot) # On reactualise l'item forgé afin que le troisième item_modifier disparaisse de l'affichage
						
						inventory_data['inventory'].append(dragged_item) # On ajoute cet item_modifier à l'inventaire
						display_items() # Et on réaffiche les items de l'inventaire
						
					5: # Si l'objet vient de equiped_armor_inventory_slot
						inventory_data['inventory'].append(dragged_item) # On ajoute l'armure à l'inventaire
						display_items() # On réaffiche les items de l'inventaire
						reset_equiped_armor_item() # Et on désélectionne l'amure équipée.
						
					6: # Si l'objet vient de equiped_weapon_inventory_slot
						inventory_data['inventory'].append(dragged_item) # On ajoute l'arme à l'inventaire
						display_items() # On réaffiche les items de l'inventaire
						reset_equiped_weapon_item() # Et on désélectionne l'arme équipée.
		
		1: # Maintenant, si le collider sur lequel l'item est laché est modified_item_inventory_slot (donc l'item forgé)
			if collider.item == null: # On vérifie qu'il n'y a pas deja un item en train d'être forgé.
				if initial_slot.slot_type == InventorySlot.SLOT_TYPE.IN_INVENTORY: # Si l'item qui a été laché vient de l'inventaire.
					inventory_data['inventory'].erase(dragged_item) # Alors on supprime l'item de l'inventaire
					display_items() # On réaffiche les items de l'inventaire 
					set_forge_modified_item(dragged_slot) # Et on met a jour l'item forgé avec l'item qui a été drag&drop
				
				# Cependant si l'item vient directement des Objets Equipés alors les instructions sont différentes
				match dragging_colliders.find(initial_slot):
					5: # Si il vient de equiped_armor_inventory_slot (l'armure équipée)
						set_forge_modified_item(dragged_slot) # On met a jour l'item forgé avec l'item qui a été drag&drop
						reset_equiped_armor_item() # Et on désélectionne l'amure équipée.
					6: # Si il vient de equiped_weapon_inventory_slot (l'arme équipée)
						set_forge_modified_item(dragged_slot) # On met a jour l'item forgé avec l'item qui a été drag&drop
						reset_equiped_weapon_item() # Et on désélectionne l'arme équipée.
		
		2: # first_item_modifier_slot
			if dragged_item is ItemModifier: # Vérifie si l'item drag&drop est bien un Item Modifier
				if collider.item == null: # Vérifie que l'Inventory Slot où l'item a étét laché est bien vide
					collider.item = dragged_item # Séléction de l'item drag&drop en tant qu'item forgé
					modified_item_inventory_slot.item.first_item_modifier = dragged_item # Met à jour l'item forgé afin de lui rajouter un item_modifier
					if initial_slot.slot_type == InventorySlot.SLOT_TYPE.IN_INVENTORY: # Si l'item qui a été laché vient de l'inventaire.
						inventory_data['inventory'].erase(dragged_item) # Suprrime l'item de l'inventaire principale 
						display_items() # Refresh l'affichage de l'inventaire
					else: # Si l'item ne vient pas de l'inventaire, alors il vient des autres slots Item Modifiers de l'item forgé
						match dragging_colliders.find(initial_slot):
							3: # Si c'est le Second Item Modifier 
								modified_item_inventory_slot.item.second_item_modifier = null # On l'enlève
								set_forge_modified_item(modified_item_inventory_slot) # Et on refresh l'affichage de l'item forgé
							4: # Si c'est le Troisième Item Modifier 
								modified_item_inventory_slot.item.third_item_modifier = null # On l'enlève
								set_forge_modified_item(modified_item_inventory_slot) # Et on refresh l'affichage de l'item forgé
		
		
		3: # second_item_modifier_slot
			if dragged_item is ItemModifier: # Vérifie si l'item drag&drop est bien un Item Modifier
				if collider.item == null: # Vérifie que l'Inventory Slot où l'item a étét laché est bien vide
					collider.item = dragged_item # Séléction de l'item drag&drop en tant qu'item forgé
					modified_item_inventory_slot.item.second_item_modifier = dragged_item # Met à jour l'item forgé afin de lui rajouter un item_modifier
					if initial_slot.slot_type == InventorySlot.SLOT_TYPE.IN_INVENTORY: # Si l'item qui a été laché vient de l'inventaire.
						inventory_data['inventory'].erase(dragged_item) # Suprrime l'item de l'inventaire principale 
						display_items() # Refresh l'affichage de l'inventaire
					else: # Si l'item ne vient pas de l'inventaire, alors il vient des autres slots Item Modifiers de l'item forgé
						match dragging_colliders.find(initial_slot):
							2: # Si c'est le Premier Item Modifier 
								modified_item_inventory_slot.item.first_item_modifier = null # On l'enlève
								set_forge_modified_item(modified_item_inventory_slot) # Et on refresh l'affichage de l'item forgé
							4: # Si c'est le Troisième Item Modifier 
								modified_item_inventory_slot.item.third_item_modifier = null # On l'enlève
								set_forge_modified_item(modified_item_inventory_slot) # Et on refresh l'affichage de l'item forgé
				
		4: # third_item_modifier_slot
			if dragged_item is ItemModifier: # Vérifie si l'item drag&drop est bien un Item Modifier
				if collider.item == null: # Vérifie que l'Inventory Slot où l'item a étét laché est bien vide
					collider.item = dragged_item # Séléction de l'item drag&drop en tant qu'item forgé
					modified_item_inventory_slot.item.third_item_modifier = dragged_item # Met à jour l'item forgé afin de lui rajouter un item_modifier
					if initial_slot.slot_type == InventorySlot.SLOT_TYPE.IN_INVENTORY: # Si l'item qui a été laché vient de l'inventaire.
						inventory_data['inventory'].erase(dragged_item) # Suprrime l'item de l'inventaire principale 
						display_items() # Refresh l'affichage de l'inventaire
					else: # Si l'item ne vient pas de l'inventaire, alors il vient des autres slots Item Modifiers de l'item forgé
						match dragging_colliders.find(initial_slot):
							2: # Si c'est le Premier Item Modifier 
								modified_item_inventory_slot.item.first_item_modifier = null # On l'enlève
								set_forge_modified_item(modified_item_inventory_slot) # Et on refresh l'affichage de l'item forgé
							4: # Si c'est le Second Item Modifier 
								modified_item_inventory_slot.item.second_item_modifier = null # On l'enlève
								set_forge_modified_item(modified_item_inventory_slot) # Et on refresh l'affichage de l'item forgé
					
		5: # equiped_armor_slot
			if dragged_item is Armor: # On vérifie que l'item est bien une Armure
				if collider.item == null: # On vérifie que le slot est vide
					equip_armor_item(dragged_slot) # On equipe l'amure
					if initial_slot.slot_type == InventorySlot.SLOT_TYPE.IN_INVENTORY: # Si l'item drag&drop vient de l'inventaire
							inventory_data['inventory'].erase(dragged_item) # On supprime l'armure de l'inventaire
							display_items() # Et on redisplay l'inventaire
					else: # Si l'item ne vient pas de l'inventaire
						match dragging_colliders.find(initial_slot):
							1: # S'il vient de la forge
								reset_forge_modified_item() # On le retire de la forge.
			
		6: # equiped_weapon_slot
			if dragged_item is Weapon: # On vérifie que l'item est bien une Arme
				if collider.item == null: # On vérifie que le slot est vide
					equip_weapon_item(dragged_slot) # On equipe l'arme
					if initial_slot.slot_type == InventorySlot.SLOT_TYPE.IN_INVENTORY: # Si l'item drag&drop vient de l'inventaire
							inventory_data['inventory'].erase(dragged_item) # On supprime l'arme de l'inventaire
							display_items() # Et on redisplay l'inventaire
					else: # Si l'item ne vient pas de l'inventaire
						match dragging_colliders.find(initial_slot):
							1: # S'il vient de la forge
								reset_forge_modified_item() # On le retire de la forge.
								
	# Finalement on met le sprite qui suivait la caméra en invisible
	dragged_item_texture_rect.visible = false
	# Et on remet à zero les variables qui servait au drag&drop pour la prochaine utilisation.
	is_dragging = false 
	dragged_item = null
	dragged_slot = null
	
	

func _input(_event:InputEvent) -> void:
	
	# Inventory Container Managment
	var menu_dir = int(Input.get_axis("move_ui_left","move_ui_right"))
	if Input.is_action_just_pressed("move_ui_left") or Input.is_action_just_pressed("move_ui_right"):
		inventory_tab_index = posmod(inventory_tab_index + menu_dir, category_tab_container.get_child_count())
		update_inventory_tabContainer()
	if Input.is_action_just_pressed("ui_accept"):
		display_ui(a)
	elif Input.is_action_just_pressed('ui_cancel'):
		a = hide_ui()

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
					
					item_slot.slot_pressed.connect(start_dragging)
					item_slot.slot_released.connect(stop_dragging)
					targeted_container.add_child(item_slot)
				
			TAB_CONTAINER_PARTS.WEAPON:
				for item_index in inventory_data['inventory'].size():
					var item = inventory_data['inventory'][item_index]
					if item.class_type == GlobalItemsMgmt.TYPE_OF_ITEMS.WEAPON:
						var item_slot: InventorySlot = inventorySlot.instantiate()
						item_slot.item = item
						
						item_slot.slot_pressed.connect(start_dragging)
						item_slot.slot_released.connect(stop_dragging)
						targeted_container.add_child(item_slot)
						
			TAB_CONTAINER_PARTS.ARMOR:
				for item_index in inventory_data['inventory'].size():
					var item = inventory_data['inventory'][item_index]
					if item.class_type == GlobalItemsMgmt.TYPE_OF_ITEMS.ARMOR:
						var item_slot: InventorySlot = inventorySlot.instantiate()
						item_slot.item = item
						
						item_slot.slot_pressed.connect(start_dragging)
						item_slot.slot_released.connect(stop_dragging)
						targeted_container.add_child(item_slot)
						
			TAB_CONTAINER_PARTS.ITEM_MODIFIER:
				for item_index in inventory_data['inventory'].size():
					var item = inventory_data['inventory'][item_index]
					if item.class_type == GlobalItemsMgmt.TYPE_OF_ITEMS.ITEM_MODIFIER:
						var item_slot: InventorySlot = inventorySlot.instantiate()
						item_slot.item = item
						
						item_slot.slot_pressed.connect(start_dragging)
						item_slot.slot_released.connect(stop_dragging)
						targeted_container.add_child(item_slot)




# ITEM FORGERY SYSTEM
func reset_forge_modified_item():
	"""Remove the selected Item in the Main Inventory Slot of the Forgery and set it to empty."""
	# Réinitialisation de toutes les variables et des textes affichés
	modified_item_name.text = "Forge"
	modified_item_description.text = ""
	item_forge_item_modifier_tab_container.current_tab = 1
	modified_item_inventory_slot.item = null
	
func set_forge_modified_item(slot: InventorySlot):
	"""Set the selected Item in the Main Inventory Slot of the Forgery to the item contain in the slot gived as a parameter."""
	# Initialisation de l'affichage de l'item
	var new_item = slot.item
	modified_item_name.text = new_item.name
	modified_item_description.text = new_item.description
	modified_item_inventory_slot.item = new_item
	modified_item_inventory_slot.refresh_item()
	# EN fonction du type de l'item, 
	match new_item.class_type:
		# Si c'est une armure ou une arme, je parcours les items_modifier de l'item et je les affiche sur les slots réspectifs. Sinon je retire les slots des Items Modifiers de l'affichage.
		GlobalItemsMgmt.TYPE_OF_ITEMS.ARMOR: 
			var item_modifiers: Array[ItemModifier] = new_item.get_item_modifiers(true)
			for item_modifier_container_index in item_forge_item_modifier_h_container.get_child_count():
				var item_modifier_slot = item_forge_item_modifier_h_container.get_child(item_modifier_container_index).get_child(0)
				item_modifier_slot.item = item_modifiers[item_modifier_container_index]
			item_forge_item_modifier_tab_container.current_tab = 0
			
		GlobalItemsMgmt.TYPE_OF_ITEMS.WEAPON:
			var item_modifiers: Array[ItemModifier] = new_item.get_item_modifiers(true)
			for item_modifier_container_index in item_forge_item_modifier_h_container.get_child_count():
				var item_modifier_slot = item_forge_item_modifier_h_container.get_child(item_modifier_container_index).get_child(0)
				item_modifier_slot.item = item_modifiers[item_modifier_container_index]
			item_forge_item_modifier_tab_container.current_tab = 0
			
		GlobalItemsMgmt.TYPE_OF_ITEMS.WEAPON:
			item_forge_item_modifier_tab_container.current_tab = 1
				
# ITEM EQUIPER
func equip_armor_item(slot:InventorySlot):
	"""Set the Equiped Armor to the item contain in the slot gived as a parameter."""
	if slot.item.class_type == GlobalItemsMgmt.TYPE_OF_ITEMS.ARMOR: # Vérification que l'item candidat à être équipé soit bien une armure
		var equiped_armor = slot.item 
		inventory_data["equiped_armor"] = equiped_armor # Actualise l'inventaire
		equiped_armor_inventory_slot.item = equiped_armor # Définie l'item du slot de l'armure équipée comme étant l'item candidat
		equiped_armor_inventory_slot.refresh_item() # Refresh l'affichage du slot de l'amure équipée

func reset_equiped_armor_item():
	"""Reset the equiped armor"""
	equiped_armor_inventory_slot.item = null
	inventory_data["equiped_armor"] = null
	
func equip_weapon_item(slot:InventorySlot):
	"""Set the Equiped Weapon to the item contain in the slot gived as a parameter."""
	if slot.item.class_type == GlobalItemsMgmt.TYPE_OF_ITEMS.WEAPON: # Vérification que l'item candidat à être équipé soit bien une arme
		var equiped_weapon = slot.item 
		inventory_data["equiped_weapon"] = equiped_weapon # Actualise l'inventaire
		equiped_weapon_inventory_slot.item = equiped_weapon # Définie l'item du slot de l'arme équipée comme étant l'item candidat
		equiped_weapon_inventory_slot.refresh_item() # Refresh l'affichage du slot de l'arme équipée
	
func reset_equiped_weapon_item():
	"""Reset the equiped weapon"""
	equiped_weapon_inventory_slot.item = null
	inventory_data["equiped_weapon"] = null
