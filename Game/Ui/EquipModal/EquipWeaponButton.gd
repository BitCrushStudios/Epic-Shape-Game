@tool
extends Button
class_name EquipWeaponButton

@export var weapon: WeaponResource:
	set(v):
		weapon = v
		update_weapon()
		
func update_weapon():
	if weapon.texture:
		icon = weapon.texture
	else:
		icon = null
	text = weapon.name
