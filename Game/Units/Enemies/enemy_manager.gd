extends Node
class_name EnemyManager
#func wave1():
	#await spawnOverTime(preload("./EnemyTriangle.tscn"), 10, 3)
	#await waitForTimeOrClear(20)
#func spawnOverTime(tscn:PackedScene, count: int, overTime: float):
	#var tween = create_tween()
	#tween.tween_callback(
		#func ():
			#var spawnPoint: SpawnPoint = preload("./SpawnPoint.tscn").instantiate()
			#
	#)
	#tween.set_loops(count)
func _process(_delta: float) -> void:
	if get_child_count() < 1:
		var spawnPoint: SpawnPoint = preload("./SpawnPoint.tscn").instantiate()
		add_child(spawnPoint,true)
		var map_rid = get_viewport().world_2d.navigation_map
		var rand_point = NavigationServer2D.map_get_random_point(map_rid,1,false)
		spawnPoint.global_position = rand_point
		spawnPoint.tscn = preload("./EnemyTriangle.tscn")
		pass
