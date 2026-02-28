@tool
extends Button
signal upgrade_selected(resource:UpgradeResource)
@export var facing = 1.0:
	set(v):
		facing = v
		update_facing_ui()
@export var resource:UpgradeResource:
	get():
		return resource
	set(v):
		if resource:
			resource.changed.disconnect(update_resource_ui)
		resource = v
		if resource:
			resource.changed.connect(update_resource_ui)
		update_resource_ui()

func update_facing_ui():
	if not is_inside_tree():
		await tree_entered
	%Content.visible = facing > 0
	scale.x = facing
func update_resource_ui():
	if not resource:
		return
	if not is_inside_tree():
		await tree_entered
	%TextureRect.texture = resource.texture
	%Label.text = "%s +%d" %[resource.name, resource.boost]
	
func _pressed() -> void:
	upgrade_selected.emit(resource)
	
	
func setup_ui():
	var available_upgrades = UpgradeResource.get_available_upgrades()
	var i = randi_range(0, available_upgrades.size()-1)
	resource = available_upgrades.pop_at(i).new()

@export_tool_button("Setup") var _setup = setup_ui




func _on_mouse_entered() -> void:
	pass # Replace with function body.
