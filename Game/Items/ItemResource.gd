extends Node
class_name ItemResource

@export var image: Texture2D
@export var item_name = "Item Name"
@export var description = ""


static func all_items()-> Array[ItemResource]:
	return []
	
