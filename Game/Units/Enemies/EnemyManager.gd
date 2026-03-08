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
signal enemy_health_depleted(enemy:Enemy)

var _enemies:Array[Enemy] = []
@export var enemies:Array[Enemy]:
	get():
		return _enemies
var _spawners:Array[SpawnPoint] = []
var spawners:Array[SpawnPoint]:
	get():
		return spawners
func _ready():
	child_entered_tree.connect(_child_entered_tree)
	child_exiting_tree.connect(_child_exiting_tree)
	for c in get_children(true):
		_child_entered_tree(c)
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
	
	
var waves = [
	Wave.create([
		WavePair.create(
			preload("res://Game/Units/Enemies/EnemyTriangle.tscn"), 
			5,
			preload("res://Assets/Art/Enemies/BasicTriangle/Basic Enemy.png")
		)
		],
		0.5,
	),
	Wave.create([
		WavePair.create(
			preload("res://Game/Units/Enemies/EnemyTriangle.tscn"), 
			20,
			preload("res://Assets/Art/Enemies/BasicTriangle/Basic Enemy.png")
		)
		],
		0.5,
	),
	Wave.create([
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
	Wave.create([
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
var wave_mode = WaveMode.Normal
var active_wave: Wave:
	get():
		if wave_mode == WaveMode.Normal:
			return waves[wave_index%waves.size()]
		else:
			return dev_wave
func _process(delta:float):
	if  Engine.is_editor_hint():
		return
	var basic_diff = (
		(1 if Input.is_action_just_pressed("dev_enemy_basic_up") else 0) - 
		(1 if Input.is_action_just_pressed("dev_enemy_basic_down") else 0)
	)
	if basic_diff:
		dev_enemy_basic_pair.count_max = max(0, dev_enemy_basic_pair.count_max+basic_diff)
		prints(dev_enemy_basic_pair.count_max,active_wave.pairs[0].count_max)
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
	if active_wave:
		active_wave.process(self,delta)
	
	
