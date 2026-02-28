@tool
extends UpgradeResource
class_name ExtraMassUpgradeResource

func _init():
	super()
	name ="Extra Strength"

func apply(player:PlayerResource):
	player.stat_mass += 1

static func poll(player:PlayerResource):
	if player.stat_mass>=player.stat_mass_max:
		return 0.0
	return float(player.stat_mass) / float(player.stat_mass_max)
