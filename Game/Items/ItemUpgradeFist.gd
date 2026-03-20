@tool
extends ItemResource
class_name ItemExtraFistUpgradeResource

func _init():
	super()
	name = "Fist"
	texture = preload("res://Assets/Art/Items/Fist Item Icon.png")
	base_price = 15
func apply(gameMain:GameMain):
	gameMain.weaponsManager.add_weapon(preload("res://Game/Weapons/fist.tscn").instantiate())
	prints("Weapon", gameMain.weaponsManager.weapons.size(), "/", gameMain.player.resource.stat_weapon_max)
static func poll(gameMain:GameMain):
	return 1.0 / float(max(1,gameMain.weaponsManager.weapons.size()))
