@tool
extends Resource
class_name UpgradeResource

@export var texture:Texture2D:
	set(v):
		texture = v
		emit_changed()
		
@export var name:String:
	set(v):
		name = v
		emit_changed()
		
@export var boost:int = 1:
	get():
		return boost
	set(v):
		boost = v
		emit_changed()
		
@export_custom(PROPERTY_HINT_MULTILINE_TEXT,"") 
var description:String:
	set(v):
		description = v
		emit_changed()

func _init():
	boost = 1

func apply():
	pass

static func get_available_upgrades():
	return [
		ExtraWeaponUpgradeResource,
		ExtraSpeedUpgradeResource,
		ExtraMassUpgradeResource,
		ExtraHealthUpgradeResource,
		ExtraSizeUpgradeResource,
	]
