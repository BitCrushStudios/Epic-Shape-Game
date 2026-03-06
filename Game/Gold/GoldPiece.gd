extends RigidBody2D
class_name GoldPiece

func _physics_process(delta: float) -> void:
	if not Player.instance:
		return
	var desired = (
		Player.instance.global_position - 
		global_position
	)
	if desired.length()<500.0:
		desired = ((desired.normalized() * 1000.0) - linear_velocity).limit_length(1000.0)
		apply_central_force(desired*mass)
