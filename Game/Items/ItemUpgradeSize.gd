@tool
extends ItemResource
class_name ItemExtraSizeUpgradeResource

func _init():
	super()
	name ="Extra Size"

func apply(gameMain:GameMain):
	gameMain.player.resource.stat_size += 1

static func poll(gameMain:GameMain):
	if gameMain.player.resource.stat_size>=gameMain.player.resource.stat_size_max:
		return 0.0
	return float(gameMain.player.resource.stat_size) / float(gameMain.player.resource.stat_size_max)
