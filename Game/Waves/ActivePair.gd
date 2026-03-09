@tool
extends Resource
class_name ActivePair

@export var pair: WavePair:
	set(v):
		if pair and pair.changed.is_connected(emit_changed):
			pair.changed.disconnect(emit_changed)
		pair = v
		if pair:
			pair.changed.connect(emit_changed)
		emit_changed()

@export var time = 0.0:
	set(v):
		time = v
		emit_changed()
		
@export var count:int = 0:
	set(v):
		count = v
		emit_changed()
