@tool
extends ItemResource
class_name ItemArmorPlatingResource

func _init():
	super()
	name ="Armor Plating"
	texture = preload("res://Assets/Art/Items/Armor plating Icon.png")
	description = "Increases max hp by 5"
	base_price = 15
func apply(gameMain:GameMain):
	gameMain.player.resource.stat_health += 5
	#gameMain.player.resource.health_current += 0
	# prints("Health", gameMain.player.resource.stat_health, "/", gameMain.player.resource.stat_health_max)

static func poll(gameMain:GameMain):
	#if gameMain.player.resource.health_current>=gameMain.player.resource.health_max:
		#return 0.0
	return float(gameMain.player.resource.health_current) / float(gameMain.player.resource.health_max)
