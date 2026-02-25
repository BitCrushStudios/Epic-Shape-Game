@tool
extends Node
class_name ShopButton

signal item_selected(item:ItemResource)
@export var resource:ItemResource:
	get():
		return resource
	set(v):
		if resource:
			resource.changed.disconnect(update)
		resource = v
		update()
		resource.changed.connect(update)
func update():
	if not is_inside_tree():
		await tree_entered
	if resource.texture:
		%TextureRect.texture = resource.texture
	%Label.text = resource.name

func setup():
	var all_items = ItemResource.get_available_items()
	resource = all_items[randi_range(0,all_items.size()-1)].new()
@export_tool_button("Setup") var __setup = setup
