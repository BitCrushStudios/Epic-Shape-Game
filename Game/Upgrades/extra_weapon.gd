@tool
extends UpgradeResource
class_name ExtraWeaponUpgradeResource

func _init():
	super()
	name = "Extra Weapon"

func apply():
	var weapon = preload("res://Game/Weapons/CubeWeapon.tscn").instantiate()
	Player.instance.add_child(weapon,true)
	var offset = Vector2(randf_range(-30,30),randf_range(-30,30))
	weapon.global_position = Player.instance.global_position + offset

static func poll(player:PlayerResource):
	return 1.0 / player.weapons.size()
