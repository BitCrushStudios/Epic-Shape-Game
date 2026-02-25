extends UpgradeResource
class_name ExtraSpeedUpgradeResource

func _init():
	super()
	name ="Extra Speed"

func apply():
	Player.instance.stat_speed += 1
