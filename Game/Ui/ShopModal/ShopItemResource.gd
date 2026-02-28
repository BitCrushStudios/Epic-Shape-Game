@tool
extends Resource
class_name ShopItemResource

@export var item:ItemResource:
	set(v):
		if item:
			item.changed.disconnect(changed.emit)
		item = v
		if item:
			item.changed.connect(changed.emit)
		emit_changed()
		
@export var quantity = 1:
	set(v):
		quantity = v
		emit_changed()
		
@export var price = 100:
	set(v):
		price = v
		emit_changed()
