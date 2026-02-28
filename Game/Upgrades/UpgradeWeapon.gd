@tool
extends UpgradeResource
class_name ExtraWeaponUpgradeResource

func _init():
	super()
	name = "Extra Weapon"

func apply(player:PlayerResource):
	player.weapons.append(WeaponResource.new())
	player.weapons = player.weapons

static func poll(player:PlayerResource):
	return 1.0 / float(max(1,player.weapons.size()))
