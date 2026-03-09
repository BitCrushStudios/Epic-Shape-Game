extends Sprite2D

@export var target: RigidBody2D
func _physics_process(delta: float) -> void:
	if target and target.linear_velocity:
		global_rotation = target.linear_velocity.angle()+PI/2
