@tool 
extends RigidBody2D
class_name Enemy


@export var agent:NavigationAgent2D
@onready var target_position = global_position 
var update_target_position_rate = 2.0
var update_target_position_time = 0.0
@export var experience_on_death = 1.0
@export var damage = 1.0
@export var health_max = 1.0
@onready var health_current=health_max:
	set(v):
		health_current = v
		health_changed.emit()
signal took_damage(damage:float)
signal health_depleted()
signal health_changed()

func take_damage(damage:float):
	health_current -= damage
	took_damage.emit(damage)
	if health_current<=0.0:
		health_depleted.emit()
	

func _ready():
	health_depleted.connect(_on_death)
	z_index = 0
	took_damage.connect(_recieved_damage)
	health_depleted.connect(_health_depleted)
	
func _on_death():
	Player.instance.resource.exp_add(experience_on_death)

func _body_entered(other:Node2D):
	if other is Player:
		other.resource.take_damage(damage)
func _physics_process(_delta: float) -> void:
	apply_torque(-rotation_degrees * 1000.0 * mass)
	for other in get_colliding_bodies():
		_body_entered(other)
func _recieved_damage(_damage:float):
	%Animation.play("damage")
	_particle_create(preload("./DamageParticles.tscn").instantiate())
	
func _health_depleted():
	collision_mask = 0
	collision_layer = 0
	z_index = -1
	took_damage.disconnect(_recieved_damage)
	health_depleted.disconnect(_health_depleted)
	%Animation.play("death")
	$Death.play()
	$Death.volume_db = randf_range(-2,0)
	$Death.pitch_scale = randf_range(1.2,1.5)
	await _particle_create(preload("./DeathParticles.tscn").instantiate())
	queue_free()
	
func _particle_create(particles:GPUParticles2D):
	add_child(particles,true,INTERNAL_MODE_FRONT)
	particles.emitting = true
	await particles.finished
	particles.queue_free()
	
func _enter_tree() -> void:
	if EnemyManager.instance:
		EnemyManager.instance.register(self)
func _exit_tree() -> void:
	if EnemyManager.instance:
		EnemyManager.instance.unregister(self)
		
		
