extends Enemy
class_name EnemyTriangle

func _ready():
	recieved_damage.connect(_recieved_damage)
	health_depleted.connect(_health_depleted)

func _recieved_damage(_damage:float):
	prints("health",health)
	$Sprite2D/AnimationPlayer.play("take damage")
	var particles:GPUParticles2D = preload("res://Enemies/damage.tscn").instantiate()
	add_child(particles)
	particles.emitting=true
	await particles.finished
	particles.queue_free()
func _health_depleted():
	collision_mask = 0
	collision_layer = 0
	$Sprite2D/AnimationPlayer.play("death")
	var particles:GPUParticles2D = preload("res://Enemies/death.tscn").instantiate()
	$Sprite2D.add_child(particles)
	particles.emitting=true
	await particles.finished
	particles.queue_free()
	while (await $Sprite2D/AnimationPlayer.animation_finished) != "death":
		pass
		
	queue_free()
