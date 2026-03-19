extends Resource
class_name WaveTime

@export var time = 30.0

static func create(time: float):
	var ob = WaveTime.new()
	ob.time = time
	return ob
