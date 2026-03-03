@tool
extends Resource
class_name WavePair


@export var scene:PackedScene:
	set(v):
		scene = v
		emit_changed()
@export var count:int:
	set(v):
		count = v
		emit_changed()
@export var image:Texture2D:
	set(v):
		image = v
		emit_changed()
static func create(_scene:PackedScene, _count:int, _image:Texture2D=null):
	var result = WavePair.new()
	result.scene = _scene
	result.count = _count
	result.image = _image
	return result
