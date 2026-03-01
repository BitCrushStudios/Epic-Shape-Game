extends RigidBody2D
class_name Unit

signal recieved_damage(damage:float)
signal health_depleted()
func _physics_process(_delta: float) -> void:	
	apply_torque(-rotation_degrees * 1000.0 * mass)
