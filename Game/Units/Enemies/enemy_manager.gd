extends Node
class_name EnemyManager
signal cleared()
func wave1():
	await spawnOverTime(preload("./EnemyTriangle.tscn"), 10, 3)
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
	var on_cleared = func():
		ob.triggered.emit()
		print("enemies cleared")
	var tween = create_tween()
	tween.tween_interval(time)
	tween.finished.connect(ob.triggered.emit)
	tween.finished.connect(on_timeout)
	cleared.connect(on_cleared)
	await ob.triggered
	cleared.disconnect(on_cleared)
	
	
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
	child_exiting_tree.connect(_child_exiting_tree)
	await get_tree().process_frame
	var waves:Array[Callable] = [wave1,wave2]
	for wave in waves:
		await wave.call()
		await upgrade()
		await shop()
		await equip()
	
	
func _child_exiting_tree(node:Node):
	print("Removed",get_child_count())
	await get_tree().process_frame
	if get_child_count()==0:
		cleared.emit()
		print("Cleared")
