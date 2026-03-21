@tool
extends ItemResource
class_name ItemTinyManUpgradeResource

func _init():
	super()
	name ="Tiny Man"
	texture = preload("res://Assets/Art/Items/Tiny Man Item.png")
	description = "Decreases size and greatly increases speed"
	base_price = 10

func apply(gameMain:GameMain):
	gameMain.player.resource.stat_speed += 5
	gameMain.player.resource.stat_size -= 1
	prints("Speed", gameMain.player.resource.stat_speed, "/", gameMain.player.resource.stat_speed_max)

static func poll(gameMain:GameMain):
	if gameMain.player.resource.stat_speed>=gameMain.player.resource.stat_speed_max:
		return 0.0
	return float(gameMain.player.resource.stat_speed) / float(gameMain.player.resource.stat_speed_max)
