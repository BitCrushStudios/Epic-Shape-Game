@tool
extends Button
class_name ShopButton

signal item_selected(item:ItemResource)
@export var resource:ItemResource:
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
	if resource:
		print(resource.name)
		%TextureRect.texture = resource.texture if resource.texture else null
		%Label.text = resource.name
	else:
		%TextureRect.texture = null
		%Label.text = ""
		
func _pressed() -> void:
	item_selected.emit(resource)
