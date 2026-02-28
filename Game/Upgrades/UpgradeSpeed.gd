@tool
extends UpgradeResource
class_name ExtraSpeedUpgradeResource

func _init():
	super()
	name ="Extra Speed"

func apply(player:PlayerResource):
	player.stat_speed += 1

static func poll(player:PlayerResource):
	if player.stat_speed>=player.stat_speed_max:
		return 0.0
	return float(player.stat_speed) / float(player.stat_speed_max)
