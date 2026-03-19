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
@export var condition:WaveTime
static func create(_pairs: Array[WavePair], _condition:WaveTime):
	var ob = Wave.new()
	ob.pairs = _pairs
	ob.condition = _condition
	return ob
