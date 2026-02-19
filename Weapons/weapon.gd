extends RigidBody2D
class_name Weapon

@export var damage = 1.0
var max_obstacle_radius = 30.0
var damage_ratio = 1.0

func _ready():
	body_entered.connect(_on_body_entered)
	
func _physics_process(_delta: float) -> void:
	$NavigationObstacle2D.velocity = linear_velocity
	damage_ratio = lerp(
		clampf(linear_velocity.length()/100.0, 0.0, 1.0),
		damage_ratio,
		_delta
	)
	$NavigationObstacle2D.radius = damage_ratio * max_obstacle_radius
		
func _on_body_entered(body:Node2D):
	if body is RigidBody2D:
		if body.linear_velocity.length()>linear_velocity.length():
			return
		if body is Enemy:
			body.apply_damage(damage_ratio * damage)
	
