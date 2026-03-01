extends Node
class_name EnemyManager
static var instance:EnemyManager
var wave_time_max = 30.0
var wave_time_current = 0.0
func wave1():
	await spawnWhileKeepingPopulation(preload("./EnemyTriangle.tscn"), 10, 30, 0.1)
	await waitForTimeOrClear(60)
	print("finished wave 1")
func wave2():
	await spawnOverTime(preload("./EnemyTriangle.tscn"), 10, 3)
	await spawnOverTime(preload("./EnemyTriangle.tscn"), 30, 10)
	await waitForTimeOrClear(60)
	print("finished wave 2")
	
	
class Multiwait:
	signal triggered()

func waitForTimeOrClear(time:float):
	
	var ob = Multiwait.new()
	var on_timeout = func():
		ob.triggered.emit()
		print("wave time out")
	var tween = create_tween()
	tween.tween_interval(time)
	tween.finished.connect(ob.triggered.emit)
	tween.finished.connect(on_timeout)
	var on_enemies_changed = func():
		if enemies.size()==0:
			ob.triggered.emit()
	enemies_changed.connect(on_enemies_changed)
	await ob.triggered
	enemies_changed.disconnect(on_enemies_changed)
	
func spawnWhileKeepingPopulation(tscn:PackedScene, count: int, timeSpan: float, interval:float):

	var tween = create_tween()
	tween.tween_callback(func():
		prints("check", enemies.size(), spawners.size(), enemies.size()+spawners.size(), count)
		if (enemies.size()+spawners.size())<count:
			var spawnPoint: SpawnPoint = preload("./SpawnPoint.tscn").instantiate()
			add_child(spawnPoint,true)
			var map_rid = get_viewport().world_2d.navigation_map
			var rand_point = NavigationServer2D.map_get_random_point(map_rid,1,false)
			spawnPoint.global_position = rand_point
			spawnPoint.tscn = tscn
	)
	tween.tween_interval(interval)
	tween.set_loops()
	
	await create_tween().tween_interval(timeSpan).finished
	tween.kill()
	
	
	
	
	
func spawnOverTime(tscn:PackedScene, count: int, overTime: float):
	var tween = create_tween()
	tween.tween_callback(
		func ():
			var spawnPoint: SpawnPoint = preload("./SpawnPoint.tscn").instantiate()
			add_child(spawnPoint,true)
			var map_rid = get_viewport().world_2d.navigation_map
			var rand_point = NavigationServer2D.map_get_random_point(map_rid,1,false)
			spawnPoint.global_position = rand_point
			spawnPoint.tscn = tscn
	)
	tween.tween_interval(overTime/count)
	tween.set_loops(count)
	await tween.finished
func upgrade():
	await Player.instance.show_upgrade_modal()
		
func shop():	
	await Player.instance.show_shop_modal()
		
func equip():
	await Player.instance.show_equip_modal()
	
func _ready():
	EnemyManager.instance = self
	await get_tree().process_frame
	var waves:Array[Callable] = [wave1,wave2]
	for wave in waves:
		await wave.call()
		await upgrade()
		await shop()
		await equip()
		
signal enemy_added(enemy:Enemy)
signal enemy_removed(enemy:Enemy)
signal enemies_changed()
var enemies:Array[Enemy]
func register(enemy:Enemy):
	enemies.append(enemy)
	enemies = enemies
	enemy_added.emit(enemy)
	enemies_changed.emit()
func unregister(enemy:Enemy):
	enemies.erase(enemy)
	enemies = enemies
	enemy_removed.emit(enemy)
	enemies_changed.emit()
	
signal spawners_chanced()
var spawners:Array[SpawnPoint]
func register_spawner(spawner:SpawnPoint):
	spawners.append(spawner)
	spawners_chanced.emit()
func unregister_spawner(spawner:SpawnPoint):
	spawners.erase(spawner)
	spawners_chanced.emit()
	
	
	
	
	
