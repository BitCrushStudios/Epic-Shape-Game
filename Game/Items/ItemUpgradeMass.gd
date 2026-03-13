@tool
extends ItemResource
class_name ItemExtraMassUpgradeResource

func _init():
	super()
	name ="Extra Strength"

func apply(gameMain:GameMain):
	gameMain.player.resource.stat_mass += 1

static func poll(gameMain:GameMain):
	if gameMain.player.resource.stat_mass>=gameMain.player.resource.stat_mass_max:
		return 0.0
	return float(gameMain.player.resource.stat_mass) / float(gameMain.player.resource.stat_mass_max)
