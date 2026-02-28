@tool 
extends Unit
class_name Enemy


@export var agent:NavigationAgent2D
@onready var target_position = global_position 
var update_target_position_rate = 2.0
var update_target_position_time = 0.0
@export var experience_on_death = 1.0
@export var damage = 1.0

	


func _ready():
	health_depleted.connect(_on_death)
	z_index = 0
	recieved_damage.connect(_recieved_damage)
	health_depleted.connect(_health_depleted)
	#body_entered.connect(_body_entered)
	
func _on_death():
	Player.instance.resource.experience += experience_on_death

func _body_entered(other:Node2D):
	if other is Player:
		other.apply_damage(damage)
func _physics_process(_delta: float) -> void:
	super(_delta)
	for other in get_colliding_bodies():
		_body_entered(other)
func _recieved_damage(_damage:float):
	%Animation.play("damage")
	_particle_create(preload("./DamageParticles.tscn").instantiate())
	
func _health_depleted():
	collision_mask = 0
	collision_layer = 0
	z_index = -1
	recieved_damage.disconnect(_recieved_damage)
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
	
