@tool
extends Button
class_name ShopButton


signal item_selected(item:ShopItemResource)
@export var resource:ShopItemResource:
	set(v):
		if resource:
			resource.changed.disconnect(resource_changed)
		resource = v
		if resource:
			resource.changed.connect(resource_changed)
		resource_changed()
func resource_changed():
	print("RC")
	if not is_inside_tree():
		await tree_entered
	print(resource)
	if resource and resource.item:
		print(resource.item.name)
		%TextureRect.texture = resource.item.texture if resource.item.texture else null
		%Label.text = resource.item.name
		disabled = resource.quantity<=0
		modulate = Color.DIM_GRAY if disabled else Color.WHITE
	else:
		%TextureRect.texture = null
		%Label.text = ""
		disabled=true
		
func _pressed() -> void:
	print("SE")
	item_selected.emit(resource)
