@tool
extends Resource
class_name ActiveWave

@export var wave: Wave:
	set(v):
		if wave and wave.changed.is_connected(emit_changed):
			wave.changed.disconnect(emit_changed)
		wave = v
		if wave:
			wave.changed.connect(emit_changed)
			var _pairs : Array[ActivePair] = []
			for p in wave.pairs:
				var _p = ActivePair.new()
				_p.pair = p
				_pairs.append(_p)
			pairs = _pairs
		emit_changed()

@export var time = 0.0:
	set(v):
		time = v
		emit_changed()
		
@export var pairs:Array[ActivePair] = []:
	set(v):
		for p in pairs:
			if p and p.changed.is_connected(emit_changed):
				p.changed.disconnect(emit_changed)
		pairs = v
		for p in pairs:
			if p:
				p.changed.connect(emit_changed)
		emit_changed()
