@tool
extends UpgradeResource
class_name ExtraSizeUpgradeResource

func _init():
	super()
	name ="Extra Size"

func apply(player:PlayerResource):
	player.stat_size += 1

static func poll(player:PlayerResource):
	if player.stat_size>=player.stat_size_max:
		return 0.0
	return float(player.stat_size) / float(player.stat_size_max)
