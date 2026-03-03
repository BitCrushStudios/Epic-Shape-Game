@tool
extends Resource
class_name ActiveWave


@export var wave:PopulationWave
@export var instance_counts: Array[int] = []
@export var time_current = 0.0
@export var interval_current = 0.0

static func create(_wave:PopulationWave):
	var ob = ActiveWave.new()
	ob.wave = _wave
	return ob
func process(root:Node, delta:float):
	instance_counts.resize(wave.pairs.size())
	time_current += delta
	interval_current += delta
	if interval_current>=wave.interval_max:
		while interval_current>wave.interval_max:
			interval_current -= wave.interval_max
			for i in range(wave.pairs.size()):
				if instance_counts[i] < wave.pairs[i].count:
					var spawnPoint: SpawnPoint = preload("res://Game/Units/Enemies/SpawnPoint.tscn").instantiate()
					root.add_child(spawnPoint,true)
					var map_rid = root.get_viewport().world_2d.navigation_map
					var rand_point = NavigationServer2D.map_get_random_point(map_rid,1,false)
					spawnPoint.global_position = rand_point
					spawnPoint.tscn = wave.pairs[i].scene
					instance_counts[i] += 1
					spawnPoint.spawned.connect(func(node:Node):
						#nodes.append(node)
						node.tree_exiting.connect(func():
							instance_counts[i] -= 1
							#nodes.erase(node)
						)
					)
	return time_current>=wave.time_max
