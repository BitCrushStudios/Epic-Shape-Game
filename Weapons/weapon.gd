extends RigidBody2D
class_name Weapon

@export var damage = 1.0
var motion_score_max = 1.0
var motion_score_current = 0.0

func _ready():
	body_entered.connect(_on_body_entered)
	
func _physics_process(delta: float) -> void:
	if linear_velocity.length()>10.0:
		motion_score_current = min(0,motion_score_current+delta)
	else:
		motion_score_current = max(motion_score_max,motion_score_current-delta)
		
func _on_body_entered(body:Node2D):
	if body is  RigidBody2D:
		var larger_force = body.linear_velocity.length() * body.mass < linear_velocity.length() * mass * 20.0 
		
		if not larger_force:
			return
		if body is Unit:
			body.apply_damage(damage)
	
