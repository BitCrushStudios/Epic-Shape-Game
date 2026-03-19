extends ItemResource
class_name ItemUpgradeMaxHealthResource

func _init():
	super()
	name ="Extra Max Health"
	texture = preload("res://Assets/Art/User Interface/Shop/Temp/Icon Test 2.png")
	base_price = 30

func apply(gameMain:GameMain):
	gameMain.player.resource.health_current += 3
	gameMain.player.resource.stat_health += 1


static func poll(gameMain:GameMain):
	if gameMain.player.resource.stat_health>=gameMain.player.resource.stat_health_max:
		return 0.0
	return float(gameMain.player.resource.stat_health) / float(gameMain.player.resource.stat_health_max)
