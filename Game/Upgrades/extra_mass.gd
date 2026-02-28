@tool
extends UpgradeResource
class_name ExtraMassUpgradeResource

func _init():
	super()
	name ="Extra Strength"

func apply():
	Player.instance.resource.stat_mass += 1

static func poll(player:PlayerResource):
	if player.stat_mass>=player.stat_mass_max:
		return 0.0
	return player.stat_mass / player.stat_mass_max
