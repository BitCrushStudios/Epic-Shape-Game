@tool
extends ItemResource
class_name ItemExtraBowlingBallUpgradeResource

func _init():
	super()
	name = "Bowling Ball"
	texture = preload("res://Assets/Art/Items/Bowling Ball Item Icon.png")
	base_price = 50
func apply(gameMain:GameMain):
	gameMain.weaponsManager.add_weapon(preload("res://Game/Weapons/bowling_ball.tscn").instantiate())
	prints("Weapon", gameMain.weaponsManager.weapons.size(), "/", gameMain.player.resource.stat_weapon_max)
static func poll(gameMain:GameMain):
	return 1.0 / float(max(1,gameMain.weaponsManager.weapons.size()))
