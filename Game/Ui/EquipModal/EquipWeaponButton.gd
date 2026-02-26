@tool
extends Button
class_name EquipWeaponButton

@export var resource: WeaponResource:
	set(v):
		if resource:
			resource.changed.disconnect(update_resource)
		resource = v
		if resource:
			resource.changed.connect(update_resource)
		update_resource()
		
func update_resource():
	if not resource:
		text = "Weapon"
		icon = null
		return
	icon = resource.normal_texture if resource.normal_texture else null
	text = resource.name
