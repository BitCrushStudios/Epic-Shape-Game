@tool
extends ItemResource
class_name ItemExtraHealthUpgradeResource

func _init():
	super()
	name ="Extra Health"
	texture = preload("res://Assets/Art/User Interface/Shop/Temp/Icon Test 2.png")
	
func apply(gameMain:GameMain):
	gameMain.player.resource.stat_health += 1

static func poll(gameMain:GameMain):
	if gameMain.player.resource.stat_health>=gameMain.player.resource.stat_health_max:
		return 0.0
	return float(gameMain.player.resource.stat_health) / float(gameMain.player.resource.stat_health_max)
