@tool
extends ItemResource
class_name ItemCoffee

func register(weapon:Weapon):
	pass
	
func unregister(weapon:Weapon):
	pass
	
func _init():
	super()
	name = "Coffee"
	texture = preload("res://Assets/Art/Spawn Icon/SpawnIcon!.png")
