@tool
extends ItemResource
class_name ItemExtraWeaponUpgradeResource

func _init():
	super()
	name = "Tiny Cube"
	texture = preload("res://Assets/Art/Items/Cube Icon.png")
	description = "Spawns one small cube"
	base_price = 25
func apply(gameMain:GameMain):
	gameMain.weaponsManager.add_weapon(preload("res://Game/Weapons/CubeWeapon.tscn").instantiate())
	prints("Weapon", gameMain.weaponsManager.weapons.size(), "/", gameMain.player.resource.stat_weapon_max)
static func poll(gameMain:GameMain):
	return 1.0 / float(max(1,gameMain.weaponsManager.weapons.size()))
