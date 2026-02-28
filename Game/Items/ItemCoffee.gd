@tool
extends ItemResource
class_name ItemCoffee

func register(_weapon:Weapon):
	pass
	
func unregister(_weapon:Weapon):
	pass
	
func _init():
	super()
	name = "Coffee"
	texture = preload("res://Assets/Art/Spawn Icon/SpawnIcon!.png")
