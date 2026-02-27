@tool
extends Button
signal upgrade_selected(resource:UpgradeResource)
@export var resource:UpgradeResource:
	get():
		return resource
	set(v):
		if resource:
			resource.changed.disconnect(update)
		resource = v
		update()
		resource.changed.connect(update)
		
func update():
	if not resource:
		return
	if not is_inside_tree():
		await tree_entered
	%TextureRect.texture = resource.texture
	%Label.text = "%s +%d" %[resource.name, resource.boost]
	
func _pressed() -> void:
	upgrade_selected.emit(resource)
	
	
func setup():
	var available_upgrades = UpgradeResource.get_available_upgrades()
	var i = randi_range(0, available_upgrades.size()-1)
	resource = available_upgrades.pop_at(i).new()

@export_tool_button("Setup") var _setup = setup




func _on_mouse_entered() -> void:
	pass # Replace with function body.
