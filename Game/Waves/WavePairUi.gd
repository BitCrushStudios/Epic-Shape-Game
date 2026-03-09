@tool
extends Control
class_name WavePairUi

@export var resource: ActivePair:
	set(v):
		if resource and resource.changed.is_connected(resource_changed):
			resource.changed.disconnect(resource_changed)
		resource = v
		if resource:
			resource.changed.connect(resource_changed)
		resource_changed()
func resource_changed():
	if not is_inside_tree():
		await tree_entered
	$TextureRect.texture = null
	$CountLabel.text = ""
	if resource and resource.pair:
		if resource.pair.image:
			$TextureRect.texture = resource.pair.image
		$CountLabel.text = "%d/%d" % [resource.count, resource.pair.count_max]
