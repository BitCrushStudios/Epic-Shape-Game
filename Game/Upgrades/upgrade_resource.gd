@tool
extends Resource
class_name UpgradeResource

@export var texture:Texture2D:
	set(v):
		texture = v
		changed.emit()
@export var name:String:
	set(v):
		name = v
		changed.emit()
@export_custom(PROPERTY_HINT_MULTILINE_TEXT,"") 
var description:String:
	set(v):
		description = v
		changed.emit()
