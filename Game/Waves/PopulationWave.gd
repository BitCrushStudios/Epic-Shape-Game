@tool
extends Resource
class_name PopulationWave

@export var pairs: Array[WavePair]:
	set(v):
		pairs = v
		emit_changed()
var interval: float
var time_max = 30.0
var interval_max = 0.5

static func create(_pairs: Array[WavePair], _interval: float):
	var ob = PopulationWave.new()
	ob.pairs = _pairs
	ob.interval = _interval
	return ob
func start():
	var active_wave = ActiveWave.new()
	active_wave.wave = self
	return active_wave
	
