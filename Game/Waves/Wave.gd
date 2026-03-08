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

@export var time = 0.0:
	set(v):
		time = v
		emit_changed()
@export var interval_current = 0.0:
	set(v):
		interval_current = v
		emit_changed()
	
func process(root:Node, delta:float):
	time += delta
	interval_current += delta
	for p in pairs:
		if p.interval_time<p.interval_time_max:
			p.interval_time = clamp(p.interval_time + delta, 0, p.interval_time_max)
		var clump_target = max(1, (p.count_max if p.clump == -1 else p.clump) - 1)
		if p.interval_time>=p.interval_time_max and p.count<(p.count_max-clump_target):
			for i in range(clump_target):
				p.interval_time -= p.interval_time_max
				var spawnPoint: SpawnPoint = preload("res://Game/Units/Enemies/SpawnPoint.tscn").instantiate()
				root.add_child(spawnPoint,true)
				var map_rid = root.get_viewport().world_2d.navigation_map
				var rand_point = NavigationServer2D.map_get_random_point(map_rid,1,false)
				spawnPoint.global_position = rand_point
				spawnPoint.tscn = p.scene
				p.count += 1
				spawnPoint.spawned.connect(func(node:Node):
					node.tree_exiting.connect(func():
						p.count -= 1
					)
				)
	return time>=time_max
