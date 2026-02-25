@tool
extends Resource
class_name ItemResource

@export var texture: Texture2D:
	set(v):
		texture = v
		emit_changed()
@export var name = "Item Name":
	set(v):
		name = v
		emit_changed()
@export var description = "":
	set(v):
		description = v
		emit_changed()

func register(weapon:Weapon):
	pass
	
func unregister(weapon:Weapon):
	pass
	
static func get_available_items():
	return [
		ItemSoy,
		ItemCoffee,
	]
	
