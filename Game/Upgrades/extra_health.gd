@tool
extends UpgradeResource
class_name ExtraHealthUpgradeResource

func _init():
	super()
	name ="Extra Health"
	
func apply():
	Player.instance.resource.health_max += 1

static func poll(player:PlayerResource):
	if player.stat_health>=player.stat_health_max:
		return 0.0
	return player.stat_health / player.stat_health_max
