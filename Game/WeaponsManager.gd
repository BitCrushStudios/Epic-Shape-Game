extends Node2D
class_name WeaponsManager

static var instance:WeaponsManager

func add_weapon(resource: WeaponResource = null):
	var ob: Weapon = preload("res://Game/Weapons/CubeWeapon.tscn").instantiate()
	ob.resource = resource
	add_child(ob,true)
	
func _ready() -> void:
	WeaponsManager.instance = self
