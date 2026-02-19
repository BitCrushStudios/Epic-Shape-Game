@tool
extends Enemy
class_name EnemyTriangle

func _ready():
	recieved_damage.connect(_recieved_damage)
	health_depleted.connect(_health_depleted)

func _recieved_damage(_damage:float):
	if health<0:
		return
	%Animation.play("damage")
	_particle_create(preload("res://Enemies/damage.tscn").instantiate())
	
func _health_depleted():
	collision_mask = 0
	collision_layer = 0
	%Animation.play("death")
	await _particle_create(preload("res://Enemies/death.tscn").instantiate())
	queue_free()
	
func _particle_create(particles:GPUParticles2D):
	add_child(particles,true,INTERNAL_MODE_FRONT)
	particles.emitting = true
	await particles.finished
	particles.queue_free()
	
