@tool
extends Resource
class_name WavePair


@export var scene:PackedScene:
	set(v):
		scene = v
		emit_changed()
@export var image:Texture2D:
	set(v):
		image = v
		emit_changed()
@export var time_max:float:
	set(v):
		time_max = v
		emit_changed()
@export var count_max:int = 0:
	set(v):
		count_max = v
		emit_changed()
@export var clump:int = 0:
	set(v):
		clump = v
		emit_changed()
static func create(_scene:PackedScene, _count_max:int, _image:Texture2D, _clump=-1, _time_max=0.5):
	var result = WavePair.new()
	result.scene = _scene
	result.count_max = _count_max
	result.image = _image
	result.time_max = _time_max
	result.clump = _clump
	return result
