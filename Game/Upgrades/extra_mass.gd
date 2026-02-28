@tool
extends UpgradeResource
class_name ExtraMassUpgradeResource

func _init():
	super()
	name ="Extra Strength"

func apply():
	Player.instance.stat_mass += 1
