@tool
extends ItemResource
class_name ItemRefillHealthUpgradeResource

func _init():
	super()
	name ="Med Kit"
	texture = preload("res://Assets/Art/Items/Med Kit Item Icon.png")
	base_price = 10
func apply(gameMain:GameMain):
	gameMain.player.resource.health_current += 5
	# prints("Health", gameMain.player.resource.stat_health, "/", gameMain.player.resource.stat_health_max)

static func poll(gameMain:GameMain):
	#if gameMain.player.resource.health_current>=gameMain.player.resource.health_max:
		#return 0.0
	return float(gameMain.player.resource.health_current) / float(gameMain.player.resource.health_max)
