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
	if not is_inside_tree():
		await tree_entered
	if resource and resource.item:
		%TextureRect.texture = resource.item.texture if resource.item.texture else null
		%NameLabel.text = resource.item.name
		%DescriptionLabel.text = resource.item.description
		%PriceLabel.text = "$ %d" % resource.price
		disabled = resource.quantity<=0
		modulate = Color.DIM_GRAY if disabled else Color.WHITE
	else:
		%TextureRect.texture = null
		%NameLabel.text = ""
		%DescriptionLabel.text = ""
		%PriceLabel.text = ""
		disabled=true
		
func _pressed() -> void:
	item_selected.emit(resource)

@export_tool_button("Trigger") var _trigger = _pressed
