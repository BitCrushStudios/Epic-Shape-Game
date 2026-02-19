extends Node
class_name EnemyManager

func _process(_delta: float) -> void:
	if get_child_count() < 10.0:
		
		var spawnPoint: SpawnPoint = preload("res://Enemies/SpawnPoint.tscn").instantiate()
		add_child(spawnPoint)
		var map_rid = get_viewport().world_2d.navigation_map
		var rand_point = NavigationServer2D.map_get_random_point(map_rid,1,false)
		spawnPoint.global_position = rand_point
		spawnPoint.tscn = preload("res://Enemies/EnemyTriangle.tscn")
