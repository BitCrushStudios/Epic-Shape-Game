@tool
extends ItemResource
class_name ItemExtraSpeedUpgradeResource

func _init():
	super()
	name ="Extra Speed"
	texture = preload("res://Assets/Art/Items/Speed Icon.png")

func apply(gameMain:GameMain):
	gameMain.player.resource.stat_speed += 1

static func poll(gameMain:GameMain):
	if gameMain.player.resource.stat_speed>=gameMain.player.resource.stat_speed_max:
		return 0.0
	return float(gameMain.player.resource.stat_speed) / float(gameMain.player.resource.stat_speed_max)
