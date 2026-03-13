@tool
extends ItemResource
class_name ItemExtraWeaponUpgradeResource

func _init():
	super()
	name = "Extra Weapon"
	texture = preload("res://Assets/Art/Items/Cube Icon.png")

func apply(gameMain:GameMain):
	gameMain.weaponsManager.weapons.append(WeaponResource.new())

static func poll(gameMain:GameMain):
	return 1.0 / float(max(1,gameMain.weaponsManager.weapons.size()))
