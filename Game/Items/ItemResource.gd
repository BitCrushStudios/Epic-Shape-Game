@tool
extends Resource
class_name ItemResource

@export var texture: Texture2D:
	set(v):
		texture = v
		emit_changed()
		
@export var name:String:
	set(v):
		print("n", v)
		name = v
		emit_changed()
		
@export var description:String:
	set(v):
		description = v
		emit_changed()

func register(_weapon:Weapon):
	pass
	
func unregister(_weapon:Weapon):
	pass
	
static func get_available_items():
	return [
		ItemSoy,
		ItemCoffee,
	]
	
func _init():
	texture = preload("res://Assets/Art/User Interface/Shop/Item Size Test.png")
	name = "Item Name"
	description = ""
