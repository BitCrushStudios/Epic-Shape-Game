extends Node
class_name RotateTowardsVelocity

@export var body:RigidBody2D
@export var target:Node2D
var direction = Vector2.RIGHT
func _process(_delta: float) -> void:
	#if not body.linear_velocity:
		#return
	direction = body.linear_velocity
	if body.linear_velocity.x>1:
		create_tween().tween_property(target, "scale", Vector2(1,1), 0.05)
	elif body.linear_velocity.x<-1:
		create_tween().tween_property(target, "scale", Vector2(1,-1), 0.05)
	target.global_rotation = Vector2.RIGHT.angle_to(direction.normalized())
