@tool
extends Button
class_name ShopButton


signal item_selected(item:ShopItemResource)
@export var resource:ShopItemResource:
	set(v):
		if resource:
			resource.changed.disconnect(_changed)
		resource = v
		if resource:
			resource.changed.connect(_changed)
		_changed()

func _changed():
	if not is_inside_tree():
		await tree_entered
	if resource and resource.item:
		%TextureRect.texture = resource.item.texture if resource.item.texture else null
		%NameLabel.text = resource.item.name
		%DescriptionLabel.text = resource.item.description
		%PriceLabel.text = "$ %d" % resource.price
		disabled = resource.quantity<=0
	else:
		%TextureRect.texture = null
		%NameLabel.text = ""
		%DescriptionLabel.text = ""
		%PriceLabel.text = ""
		disabled=true
	modulate = Color.DIM_GRAY if disabled else Color.WHITE
		
func _pressed() -> void:
	print("Selected")
	item_selected.emit(resource)
func _randomize():
	var items = ItemResource.get_available_items()
	resource = ShopItemResource.new()
	resource.item = items[randi_range(0, items.size()-1)].new()
	resource.quantity = 1
	resource.price = randi_range(1, 10) * 10
@export_tool_button("Randomize") var _trigger = _randomize
