@tool
extends Node
class_name EnemyManager
static var instance:EnemyManager
					
var wave_index = 0

signal enemy_added(enemy:Enemy)
signal enemy_removed(enemy:Enemy)
signal enemies_changed()
signal spawners_chanced()
signal resource_changed()
signal wave_finished()
@export var enemy_basic_pair = WavePair.create(
		preload("res://Game/Units/Enemies/EnemyTriangle.tscn"), 
		0,
		preload("res://Assets/Art/Enemies/BasicTriangle/Basic Enemy.png")
	)
@export var enemy_roller_pair = WavePair.create(
		preload("res://Game/Units/Enemies/EnemyRoller.tscn"), 
		0,
		preload("res://Assets/Art/Enemies/Roller/Roller.png")
	)
@export var enemy_tank_pair = WavePair.create(
		preload("res://Game/Units/Enemies/EnemyTank.tscn"), 
		0,
		preload("res://Assets/Art/Enemies/Tank/Tank.png")
	)
@export var active_wave: ActiveWave = ActiveWave.create(
	PopulationWave.create([
		enemy_basic_pair,
		enemy_roller_pair,
		enemy_tank_pair
	],0.5)
):
	set(v):
		if active_wave and active_wave.changed.is_connected(resource_changed.emit):
			active_wave.changed.disconnect(resource_changed.emit)
		active_wave = v
		if active_wave:
			active_wave.changed.connect(resource_changed.emit)
		resource_changed.emit()

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
	
var spawners:Array[SpawnPoint]
func register_spawner(spawner:SpawnPoint):
	spawners.append(spawner)
	spawners_chanced.emit()
func unregister_spawner(spawner:SpawnPoint):
	spawners.erase(spawner)
	spawners_chanced.emit()
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
func _ready():
	EnemyManager.instance = self
		
func _process(delta:float):
	if Engine.is_editor_hint():
		return
	if active_wave:
		active_wave.process(self,delta)
	var basic_diff = (1 if Input.is_action_just_pressed("dev_enemy_basic_up") else 0 - 1 if Input.is_action_just_pressed("dev_enemy_basic_down") else 0)
	if basic_diff:
		enemy_basic_pair.count = max(0, enemy_basic_pair.count+basic_diff)
		resource_changed.emit()
	var roller_diff = (1 if Input.is_action_just_pressed("dev_enemy_roller_up") else 0 - 1 if Input.is_action_just_pressed("dev_enemy_roller_down") else 0)
	if roller_diff:
		enemy_roller_pair.count = max(0, enemy_roller_pair.count+roller_diff)
		resource_changed.emit()
	var tank_diff = (1 if Input.is_action_just_pressed("dev_enemy_tank_up") else 0 - 1 if Input.is_action_just_pressed("dev_enemy_tank_down") else 0)
	if tank_diff:
		enemy_tank_pair.count = max(0, enemy_tank_pair.count+tank_diff) 
		resource_changed.emit()
	
	
