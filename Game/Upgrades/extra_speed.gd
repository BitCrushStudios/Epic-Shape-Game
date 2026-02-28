@tool
extends UpgradeResource
class_name ExtraSpeedUpgradeResource

func _init():
	super()
	name ="Extra Speed"

func apply():
	Player.instance.resource.stat_speed += 1

static func poll(player:PlayerResource):
	if player.stat_speed>=player.stat_speed_max:
		return 0.0
	return player.stat_speed / player.stat_speed_max
