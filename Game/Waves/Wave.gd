@tool
extends Resource
class_name Wave

@export var pairs: Array[WavePair]:
	set(v):
		for p in pairs:
			p.changed.disconnect(changed.emit)
		pairs = v
		for p in pairs:
			p.changed.connect(changed.emit)
		emit_changed()
@export var time_max =  10
static func create(_pairs: Array[WavePair], _time_max: float = 30.0):
	var ob = Wave.new()
	ob.pairs = _pairs
	ob.time_max = _time_max
	return ob
