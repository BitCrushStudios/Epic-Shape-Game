@tool
extends Node
class_name EnemyManager
static var instance:EnemyManager
@export var wave_index = 0:
	get():
		return wave_index
	set(i):
		wave_index = i
		var wave = waves[i%waves.size()]
		var _active = ActiveWave.new()
		_active.wave = wave
		resource = _active
		

signal enemy_added(enemy:Enemy)
signal enemy_removed(enemy:Enemy)
signal enemies_changed()
signal spawners_chanced()
signal resource_changed()
signal wave_finished()
signal enemy_health_depleted(enemy:Enemy)

@export var enemies: Array[Enemy] = []:
	get():
		return enemies
var spawners: Array[SpawnPoint] = []
func _ready():
	child_entered_tree.connect(_child_entered_tree)
	child_exiting_tree.connect(_child_exiting_tree)
	for c in get_children(true):
		_child_entered_tree(c)
	wave_index = wave_index
func _child_entered_tree(node:Node):
	if node is Enemy:
		enemies.append(node)
		node.health_depleted.connect(enemy_health_depleted.emit.bind(node))
		enemies = enemies
		enemy_added.emit(node)
		enemies_changed.emit()
	if node is SpawnPoint:
		spawners.append(node)
		spawners_chanced.emit()
		
func _child_exiting_tree(node:Node):
	if node is Enemy:
		enemies.erase(node)
		node.health_depleted.disconnect(enemy_health_depleted.emit.bind(node))
		enemies = enemies
		enemy_removed.emit(node)
		enemies_changed.emit()
	if node is SpawnPoint:
		spawners.erase(node)
		spawners_chanced.emit()
	
	
@export var waves:Array[Wave] = [
	Wave.create([
			WavePair.create(
				preload("res://Game/Units/Enemies/EnemyTriangle.tscn"), 
				10,
				preload("res://Assets/Art/Enemies/BasicTriangle/Basic Enemy.png"),
				8
			)
		],
		WaveTime.create(10.0)
	),
	Wave.create([
			WavePair.create(
				preload("res://Game/Units/Enemies/EnemyTriangle.tscn"), 
				20,
				preload("res://Assets/Art/Enemies/BasicTriangle/Basic Enemy.png"),
				8
			)
		],
		WaveTime.create(20.0)
	),
	Wave.create([
			WavePair.create(
				preload("res://Game/Units/Enemies/EnemyTriangle.tscn"), 
				30,
				preload("res://Assets/Art/Enemies/BasicTriangle/Basic Enemy.png"),
				8
			),
		],
		WaveTime.create(40.0)
	),
	Wave.create([
			WavePair.create(
				preload("res://Game/Units/Enemies/EnemyTriangle.tscn"), 
				40,
				preload("res://Assets/Art/Enemies/BasicTriangle/Basic Enemy.png"),
				8
			),
		],
		WaveTime.create(80.0)
	),
	Wave.create([
		WavePair.create(
			preload("res://Game/Units/Enemies/EnemyTriangle.tscn"), 
			40,
			preload("res://Assets/Art/Enemies/BasicTriangle/Basic Enemy.png"),
			8
		),
		WavePair.create(
			preload("res://Game/Units/Mini Bosses/BigRed.tscn"), 
			1,
			preload("res://Assets/Art/Enemies/Mini Bosses/Big Red/Big Red.png"),
		),
		],
		WaveTime.create(140.0)
	),
	Wave.create([
			WavePair.create(
				preload("res://Game/Units/Enemies/EnemyTriangle.tscn"), 
				80,
				preload("res://Assets/Art/Enemies/BasicTriangle/Basic Enemy.png"),
				20
			),
		],
		WaveTime.create(40.0)
	),
	Wave.create([
			WavePair.create(
				preload("res://Game/Units/Enemies/EnemyRoller.tscn"), 
				80,
				preload("res://Assets/Art/Enemies/Roller/Move Animation/frame0000.png"),
				20
			),
		],
		WaveTime.create(100.0)
	),
	Wave.create([
			WavePair.create(
				preload("res://Game/Units/Enemies/EnemyTriangle.tscn"), 
				80,
				preload("res://Assets/Art/Enemies/BasicTriangle/Basic Enemy.png"),
				20
			),
			WavePair.create(
				preload("res://Game/Units/Enemies/EnemyRoller.tscn"), 
				80,
				preload("res://Assets/Art/Enemies/Roller/Move Animation/frame0000.png"),
				20
			),
		],
		WaveTime.create(40.0)
	),
	Wave.create([
			WavePair.create(
				preload("res://Game/Units/Enemies/EnemyTriangle.tscn"), 
				80,
				preload("res://Assets/Art/Enemies/BasicTriangle/Basic Enemy.png"),
				20
			),
			WavePair.create(
				preload("res://Game/Units/Enemies/EnemyRoller.tscn"), 
				80,
				preload("res://Assets/Art/Enemies/Roller/Move Animation/frame0000.png"),
				20
			),
			WavePair.create(
				preload("res://Game/Units/Mini Bosses/BigRed.tscn"), 
				1,
				preload("res://Assets/Art/Enemies/Mini Bosses/Big Red/Big Red.png"),
			),
		],
		WaveTime.create(140.0)
	),
	Wave.create([
			WavePair.create(
				preload("res://Game/Units/Enemies/EnemyTriangle.tscn"), 
				40,
				preload("res://Assets/Art/Enemies/BasicTriangle/Basic Enemy.png"),
				9
			),
			WavePair.create(
				preload("res://Game/Units/Enemies/EnemyRoller.tscn"), 
				40,
				preload("res://Assets/Art/Enemies/Roller/Move Animation/frame0000.png"),
				9
			),
			WavePair.create(
				preload("res://Game/Units/Mini Bosses/BigRed.tscn"), 
				2,
				preload("res://Assets/Art/Enemies/Mini Bosses/Big Red/Big Red.png"),
				1
			),
		],
		WaveTime.create(140.0)
	),
]:
	get():
		return waves
@export var resource: ActiveWave:
	set(v):
		if resource and resource.changed.is_connected(resource_changed.emit):
			resource.changed.disconnect(resource_changed.emit)
		resource = v
		if resource :
			resource.changed.connect(resource_changed.emit)
		resource_changed.emit()

func _process(delta:float):
	if  Engine.is_editor_hint():
		return
	if resource:
		resource.time += delta
		for p in resource.pairs:
			var clump_target = max(1, (p.pair.count_max if p.pair.clump == -1 else p.pair.clump) - 1)
			if p.time<p.pair.time_max:
				p.time = clamp(p.time + delta, 0, p.pair.time_max*clump_target)
			if p.time>=p.pair.time_max and p.count<(p.pair.count_max-(clump_target-1)):
				var map_rid = get_viewport().world_2d.navigation_map
				var rand_point = NavigationServer2D.map_get_random_point(map_rid,1,false)
				
				for i in range(clump_target):
					rand_point = NavigationServer2D.map_get_closest_point(map_rid, rand_point+Vector2.RIGHT.rotated(PI*2*randf())*50.0)
					p.time -= p.pair.time_max
					var spawnPoint: SpawnPoint = preload("res://Game/Units/Enemies/SpawnPoint.tscn").instantiate()
					add_child(spawnPoint,true)
					spawnPoint.global_position = rand_point
					spawnPoint.tscn = p.pair.scene
					p.count += 1
					spawnPoint.spawned.connect(func(node:Node):
						node.tree_exiting.connect(func():
							p.count -= 1
						)
					)
		if resource.time >= resource.wave.condition.time:
			wave_index+=1
	
	
