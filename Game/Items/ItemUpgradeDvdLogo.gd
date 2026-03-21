@tool
extends ItemResource
class_name ItemExtraDvdLogoUpgradeResource

func _init():
	super()
	name = "DVD Logo"
	texture = preload("res://Assets/Art/Items/Dvd Logo item Icon.png")
	base_price = 30
func apply(gameMain:GameMain):
	gameMain.weaponsManager.add_weapon(preload("res://Game/Weapons/DvdLogoWeapon.tscn").instantiate())
	prints("Weapon", gameMain.weaponsManager.weapons.size(), "/", gameMain.player.resource.stat_weapon_max)
static func poll(gameMain:GameMain):
	return 1.0 / float(max(1,gameMain.weaponsManager.weapons.size()))
