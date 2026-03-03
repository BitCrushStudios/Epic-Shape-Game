extends Node
class_name EnemyManager
static var instance:EnemyManager
					
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
signal wave_finished()
var waves = [
	PopulationWave.create([
		WavePair.create(
			preload("res://Game/Units/Enemies/EnemyTriangle.tscn"), 
			5,
			preload("res://Assets/Art/Enemies/BasicTriangle/Basic Enemy.png")
		)
		],
		0.5,
	),
	PopulationWave.create([
		WavePair.create(
			preload("res://Game/Units/Enemies/EnemyTriangle.tscn"), 
			20,
			preload("res://Assets/Art/Enemies/BasicTriangle/Basic Enemy.png")
		)
		],
		0.5,
	),
	PopulationWave.create([
		WavePair.create(
			preload("res://Game/Units/Enemies/EnemyTriangle.tscn"), 
			10,
			preload("res://Assets/Art/Enemies/BasicTriangle/Basic Enemy.png")
		),
		WavePair.create(
			preload("res://Game/Units/Enemies/EnemyRoller.tscn"), 
			3,
			preload("res://Assets/Art/Enemies/Roller/Roller.png")
		)
		],
		0.5,
	),
	PopulationWave.create([
			WavePair.create(
				preload("res://Game/Units/Enemies/EnemyTriangle.tscn"), 
				3,
				preload("res://Assets/Art/Enemies/BasicTriangle/Basic Enemy.png")
			),
			WavePair.create(
				preload("res://Game/Units/Enemies/EnemyRoller.tscn"), 
				6,
				preload("res://Assets/Art/Enemies/Roller/Roller.png")
			),
			WavePair.create(
				preload("res://Game/Units/Enemies/EnemyTank.tscn"), 
				6,
				preload("res://Assets/Art/Enemies/Tank/Tank.png")
			)
		],
		0.5,
	),
]
@export var active_wave: ActiveWave
var enemy_basic_pair = WavePair.create(
		preload("res://Game/Units/Enemies/EnemyTriangle.tscn"), 
		0,
		preload("res://Assets/Art/Enemies/BasicTriangle/Basic Enemy.png")
	)
var enemy_roller_pair = WavePair.create(
		preload("res://Game/Units/Enemies/EnemyRoller.tscn"), 
		0,
		preload("res://Assets/Art/Enemies/Roller/Roller.png")
	)
var enemy_tank_pair = WavePair.create(
		preload("res://Game/Units/Enemies/EnemyTank.tscn"), 
		0,
		preload("res://Assets/Art/Enemies/Tank/Tank.png")
	)
func _ready():
	EnemyManager.instance = self
	active_wave = ActiveWave.new()
	active_wave.wave = PopulationWave.create([
		enemy_basic_pair,
		enemy_roller_pair,
		enemy_tank_pair
	],0.5)
		
func _process(delta:float):
	if active_wave:
		active_wave.process(self,delta)
	enemy_basic_pair.count = max(0, enemy_basic_pair.count+Input.get_axis("dev_enemy_basic_down","dev_enemy_basic_up"))
	enemy_roller_pair.count = max(0, enemy_roller_pair.count+Input.get_axis("dev_enemy_roller_down","dev_enemy_roller_up"))
	enemy_tank_pair.count = max(0, enemy_tank_pair.count+Input.get_axis("dev_enemy_tank_down","dev_enemy_tank_up")) 
	
	
