extends UpgradeResource
class_name ExtraHealthUpgradeResource

func _init():
	super()
	name ="Extra Health"
	
func apply():
	Player.instance.health_max += 1
