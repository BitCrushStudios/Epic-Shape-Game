@tool
extends Resource
class_name ItemResource

@export var texture: Texture2D:
	get():
		return texture
	set(v):
		texture = v
		emit_changed()
@export var name:String:
	get():
		return name
	set(v):
		name = v
		emit_changed()
@export var description:String:
	get():
		return description
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
	
func _init():
	texture = null
	name = "Item Name"
	description = ""
