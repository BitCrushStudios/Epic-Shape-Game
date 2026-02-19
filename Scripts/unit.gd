extends RigidBody2D
class_name Unit

signal recieved_damage(damage:float)
signal health_depleted()
func _physics_process(_delta: float) -> void:	
	apply_torque(-rotation_degrees * 1000.0)

@export var health_max = 1.0
@onready var health_current = health_max

func apply_damage(damage:float):
	health_current -= damage
	recieved_damage.emit(damage)
	if health_current<=0:
		health_depleted.emit()
