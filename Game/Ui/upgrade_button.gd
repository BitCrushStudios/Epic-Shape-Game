@tool
extends Button
@export var upgradeModal: UpgradeModal
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
	%Label.text = resource.name
	
func _pressed() -> void:
	print("pressed")
	upgradeModal.upgrade_selected.emit(resource)
