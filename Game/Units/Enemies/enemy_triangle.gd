@tool
extends Enemy
class_name EnemyTriangle
var damage = 1.0
func _ready():
	z_index = 0
	recieved_damage.connect(_recieved_damage)
	health_depleted.connect(_health_depleted)
	#body_entered.connect(_body_entered)
	super()
func _body_entered(other:Node2D):
	if other is Player:
		other.apply_damage(damage)
func _physics_process(_delta: float) -> void:
	super(_delta)
	for other in get_colliding_bodies():
		_body_entered(other)
func _recieved_damage(_damage:float):
	%Animation.play("damage")
	_particle_create(preload("./damage.tscn").instantiate())
	
func _health_depleted():
	collision_mask = 0
	collision_layer = 0
	z_index = -1
	recieved_damage.disconnect(_recieved_damage)
	health_depleted.disconnect(_health_depleted)
	%Animation.play("death")
	$Death.play()
	await _particle_create(preload("./death.tscn").instantiate())
	queue_free()
	
func _particle_create(particles:GPUParticles2D):
	add_child(particles,true,INTERNAL_MODE_FRONT)
	particles.emitting = true
	await particles.finished
	particles.queue_free()
	
