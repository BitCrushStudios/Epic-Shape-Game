extends RigidBody2D
class_name Unit

signal recieved_damage(damage:float)
signal health_depleted()
func _physics_process(_delta: float) -> void:	
	apply_torque(-rotation_degrees * 1000.0)

var health = 1.0

func apply_damage(damage:float):
	health -= damage
	recieved_damage.emit(damage)
	print(health)
	if health<=0:
		health_depleted.emit()
