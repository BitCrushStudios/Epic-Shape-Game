extends EntityComponent
class_name HealthComponent


@export var health_max = 1.0
@export var health_current = 1.0
@export var sprite:Sprite2D
#const death_tscn: PackedScene = preload("res://World/Scenes/Enemies/Deaths/death_particle.tscn")
signal damage_received(damage: float, source: Node)
signal heal_received(heal: float, source: Node)
signal has_died()

func _init():
	health_current = health_max
	

func apply_damage(damage: float, source: Node):
	health_current -= damage
	damage_received.emit(damage, source)
	if health_current<=0.0:
		pass
		#trigger_death()

func apply_heal(heal: float, source: Node):
	health_current = min(health_current+heal, health_max)
	heal_received.emit(heal, source)
	

#func trigger_death():
	#health_current = 0.0
	#has_died.emit()
	#var death:CPUParticles2D = death_tscn.instantiate()
	#if sprite != null:
		#death.texture = sprite.texture
	#get_parent().get_parent().add_child(death)
	#death.global_position = get_parent().global_position
	#get_parent().queue_free()
	#death.restart()
	#death.finished.connect(death.queue_free)
	#
