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

@export var enemies: Array[Enemy] = []
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
	
	
@export var waves = [
	Wave.create([
			WavePair.create(
				preload("res://Game/Units/Enemies/EnemyTriangle.tscn"), 
				8,
				preload("res://Assets/Art/Enemies/BasicTriangle/Basic Enemy.png"),
				5
			)
		],
	),
	Wave.create([
			WavePair.create(
				preload("res://Game/Units/Enemies/EnemyTriangle.tscn"), 
				20,
				preload("res://Assets/Art/Enemies/BasicTriangle/Basic Enemy.png"),
				8
			)
		],
	),
	Wave.create([
			WavePair.create(
				preload("res://Game/Units/Enemies/EnemyTriangle.tscn"), 
				10,
				preload("res://Assets/Art/Enemies/BasicTriangle/Basic Enemy.png"),
				8
			),
			WavePair.create(
				preload("res://Game/Units/Enemies/EnemyRoller.tscn"), 
				3,
				preload("res://Assets/Art/Enemies/Roller/Roller.png"),
				2
			)
		],
	),
	Wave.create([
			WavePair.create(
				preload("res://Game/Units/Enemies/EnemyTriangle.tscn"), 
				3,
				preload("res://Assets/Art/Enemies/BasicTriangle/Basic Enemy.png"),
				2
			),
			WavePair.create(
				preload("res://Game/Units/Enemies/EnemyRoller.tscn"), 
				6,
				preload("res://Assets/Art/Enemies/Roller/Roller.png"),
				3
			),
			WavePair.create(
				preload("res://Game/Units/Enemies/EnemyTank.tscn"), 
				6,
				preload("res://Assets/Art/Enemies/Tank/Tank.png"),
				2
			)
		],
	),
]
@onready var dev_enemy_basic_pair = WavePair.create(
	preload("res://Game/Units/Enemies/EnemyTriangle.tscn"), 
	0,
	preload("res://Assets/Art/Enemies/BasicTriangle/Basic Enemy.png")
)
@onready var dev_enemy_roller_pair = WavePair.create(
	preload("res://Game/Units/Enemies/EnemyRoller.tscn"), 
	0,
	preload("res://Assets/Art/Enemies/Roller/Roller.png")
)
@onready var dev_enemy_tank_pair = WavePair.create(
	preload("res://Game/Units/Enemies/EnemyTank.tscn"), 
	0,
	preload("res://Assets/Art/Enemies/Tank/Tank.png")
)
@onready var dev_wave = Wave.create([
	dev_enemy_basic_pair,
	dev_enemy_roller_pair,
	dev_enemy_tank_pair,
],30.0)
enum WaveMode{
	Normal, Dev
}
@export var wave_mode = WaveMode.Normal
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
	if resource and dev_wave == resource.wave:
		var basic_diff = (
			(1 if Input.is_action_just_pressed("dev_enemy_basic_up") else 0) - 
			(1 if Input.is_action_just_pressed("dev_enemy_basic_down") else 0)
		)
		if basic_diff:
			dev_enemy_basic_pair.count_max = max(0, dev_enemy_basic_pair.count_max+basic_diff)
		var roller_diff = (
			(1 if Input.is_action_just_pressed("dev_enemy_roller_up") else 0) -
			(1 if Input.is_action_just_pressed("dev_enemy_roller_down") else 0)
		)
		if roller_diff:
			dev_enemy_roller_pair.count_max = max(0, dev_enemy_roller_pair.count_max+roller_diff)
		var tank_diff = (
			( 1 if Input.is_action_just_pressed("dev_enemy_tank_up") else 0 ) - 
			( 1 if Input.is_action_just_pressed("dev_enemy_tank_down") else 0 )
		)
		if tank_diff:
			dev_enemy_tank_pair.count_max = max(0, dev_enemy_tank_pair.count_max+tank_diff)
	if resource:
		resource.time += delta
		for p in resource.pairs:
			if p.time<p.pair.time_max:
				p.time = clamp(p.time + delta, 0, p.pair.time_max)
			var clump_target = max(1, (p.pair.count_max if p.pair.clump == -1 else p.pair.clump) - 1)
			if p.time>=p.pair.time_max and p.count<(p.pair.count_max-clump_target):
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
		if resource.time >= resource.wave.time_max:
			wave_index+=1
	
	
