@tool
extends UpgradeResource
class_name ExtraMassUpgradeResource

func _init():
	super()
	name ="Extra Strength"

func apply():
	Player.instance.resource.stat_mass += 1
