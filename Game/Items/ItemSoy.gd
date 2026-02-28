@tool
extends ItemResource
class_name ItemSoy

func register(_weapon:Weapon):
	pass
	
func unregister(_weapon:Weapon):
	pass
	
func _init():
	super()
	name = "Soy"
	texture = preload("res://Assets/Art/Spawn Icon/SpawnIcon!.png")
