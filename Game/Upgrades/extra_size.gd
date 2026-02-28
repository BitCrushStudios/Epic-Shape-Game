@tool
extends UpgradeResource
class_name ExtraSizeUpgradeResource

func _init():
	super()
	name ="Extra Size"

func apply():
	Player.instance.resource.stat_size += 1
