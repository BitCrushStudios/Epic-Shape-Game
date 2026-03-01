extends Node
class_name EnemyManager
static var instance:EnemyManager
class PopulationWave:
	var scenes: Array[PackedScene]
	var counts: Array[int]
	var interval: float
	static func create(_scenes: Array[PackedScene], _counts: Array[int], _interval: float):
		var ob = PopulationWave.new()
		ob.scenes = _scenes
		ob.counts = _counts
		ob.interval = _interval
		return ob
		
class ActiveWave:
	var wave:PopulationWave
	var time_max = 30.0
	var time_current = 0.0
	var interval_max = 0.5
	var interval_current = 0.0
	var root: EnemyManager
	signal finished()
	func _init(_root: EnemyManager, _wave:PopulationWave):
		root = _root
		wave = _wave
	func _process(delta: float):
		time_current+=delta
		if interval_current<interval_max:
			interval_current+=delta
		if time_current>=time_max:
			finished.emit()
		else:
			if (root.enemies.size()+root.spawners.size())<wave.counts[0]:
				while interval_current>interval_max:
					interval_current -= interval_max
					var spawnPoint: SpawnPoint = preload("./SpawnPoint.tscn").instantiate()
					root.add_child(spawnPoint,true)
					var map_rid = root.get_viewport().world_2d.navigation_map
					var rand_point = NavigationServer2D.map_get_random_point(map_rid,1,false)
					spawnPoint.global_position = rand_point
					spawnPoint.tscn = wave.scenes[0]
					
var wave_index = 0
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
var waves = [
	PopulationWave.create([preload("res://Game/Units/Enemies/EnemyTriangle.tscn")],[10],0.5),
	PopulationWave.create([preload("res://Game/Units/Enemies/EnemyTriangle.tscn")],[20],1.0),
	PopulationWave.create([preload("res://Game/Units/Enemies/EnemyTriangle.tscn")],[40],1.0),
]
var active_wave: ActiveWave
func _ready():
	EnemyManager.instance = self
	await get_tree().process_frame
	var i = 0
	while true:
		active_wave = ActiveWave.new(self, waves[i])
		await active_wave.finished
		active_wave = null
		
		await Player.instance.show_upgrade_modal()
		#await Player.instance.show_shop_modal()
		#await Player.instance.show_equip_modal()
		i = (i + 1) % waves.size()
		
func _process(delta:float):
	if active_wave:
		active_wave._process(delta)
	
	
	
