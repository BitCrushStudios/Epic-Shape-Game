@tool
extends ItemResource
class_name ItemRefillHealthUpgradeResource

func _init():
	super()
	name ="Refill Health"
	texture = preload("res://Assets/Art/User Interface/Shop/Temp/Icon Test 2.png")
	base_price = 0
func apply(gameMain:GameMain):
	# gameMain.player.resource.stat_health += 1
	gameMain.player.resource.health_current += 3
	# prints("Health", gameMain.player.resource.stat_health, "/", gameMain.player.resource.stat_health_max)

static func poll(gameMain:GameMain):
	if gameMain.player.resource.health_current>=gameMain.player.resource.health_max:
		return 0.0
	return float(gameMain.player.resource.health_current) / float(gameMain.player.resource.health_max)
