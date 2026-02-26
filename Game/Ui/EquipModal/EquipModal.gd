@tool
extends Control
class_name EquipModal

@export var weapons: Array[WeaponResource] = []:
	set(v):
		weapons = v
		update_weapons()
		
@export var weapon_index: int:
	set(v):
		weapon_index = v
		update_items()
		
func update_weapons():
	if not is_inside_tree():
		await tree_entered
	for c in %WeaponContainer.get_children(true):
		c.queue_free.call_deferred()
	for resource in weapons:
		var btn:EquipWeaponButton = preload("res://Game/Ui/EquipModal/EquipWeaponButton.tscn").instantiate()
		btn.resource = resource
		%WeaponContainer.add_child(btn, true, Node.INTERNAL_MODE_FRONT)
		btn.pressed.connect(weapon_selected.bindv([btn]))
	update_items()
	
func weapon_selected(btn:EquipWeaponButton):
	for c in %WeaponContainer.get_children(true):
		(c as Button).button_pressed = false
	weapon_index = btn.get_index(true)
	
	
func update_items():
	prints("Update Items For Selected Weapon")
	if not is_inside_tree():
		await tree_entered
	if weapon_index < %WeaponContainer.get_child_count(true):
		(%WeaponContainer.get_child(weapon_index,true) as EquipWeaponButton).button_pressed = true
	for c in %ItemsContainer.get_children(true):
		c.queue_free.call_deferred()
	if weapon_index < weapons.size() and weapons[weapon_index]:
		var weapon = weapons[weapon_index]
		for resource in weapon.items:
			var btn:EquipItemButton = preload("res://Game/Ui/EquipModal/EquipItemButton.tscn").instantiate()
			btn.resource = resource
			%ItemsContainer.add_child(btn, true, Node.INTERNAL_MODE_FRONT)
	
@export_tool_button("Update") var _setup = update_weapons
