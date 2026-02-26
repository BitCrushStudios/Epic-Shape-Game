@tool
extends Button
class_name EquipItemButton

@export var resource: ItemResource:
	set(v):
		if resource:
			resource.changed.disconnect(update_resource)
		resource = v
		if resource:
			resource.changed.connect(update_resource)
		update_resource()

func update_resource():
	if not resource:
		text = "Item"
		icon = null
		return
	icon = resource.texture if resource.texture else null
	text = resource.name
	
	
	
