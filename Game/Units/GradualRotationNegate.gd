extends Node
class_name GradualRotationNegate

func _physics_process(_delta: float) -> void:	
	var parent:RigidBody2D = get_parent()
	parent.apply_torque(-parent.rotation_degrees * 1000.0 * parent.mass)
