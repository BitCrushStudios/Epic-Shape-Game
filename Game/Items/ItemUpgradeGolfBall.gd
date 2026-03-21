@tool
extends ItemResource
class_name ItemExtraGolfBallUpgradeResource

func _init():
	super()
	name = "Golf Ball"
	texture = preload("res://Assets/Art/Weapons/Golf Ball/GolfBall.png")
	description = "Spawns one golf ball"
	base_price = 10
func apply(gameMain:GameMain):
	gameMain.weaponsManager.add_weapon(preload("res://Game/Weapons/GolfBallWeapon.tscn").instantiate())
	prints("Weapon", gameMain.weaponsManager.weapons.size(), "/", gameMain.player.resource.stat_weapon_max)
static func poll(gameMain:GameMain):
	return 1.0 / float(max(1,gameMain.weaponsManager.weapons.size()))
