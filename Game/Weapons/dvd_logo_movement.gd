extends Node

func _physics_process(delta: float) -> void:
	var body = (get_parent() as RigidBody2D)
	if not body.linear_velocity:
		body.linear_velocity =  Vector2.ONE
	
	body.linear_velocity = body.linear_velocity.lerp(
		Vector2(
			1 if body.linear_velocity.x>=0 else -1,
			1 if body.linear_velocity.y>=0 else -1
		) * 600.0, delta)
