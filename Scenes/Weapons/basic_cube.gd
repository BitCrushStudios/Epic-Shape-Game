extends RigidBody2D
class_name CubeLarge

@onready var hit: AudioStreamPlayer2D = $Hit
@export var is_a_homing_cube = false
@export var damage_base = 1.0
@export var damage_speed_mult = 0.1

func _on_body_entered(other: Node) -> void:
	$Ice.restart()
	$AnimationTree.get("parameters/playback").travel("Hit")
	if other.is_in_group("enemy"):# and global_position.direction_to(other.global_position).dot(linear_velocity.normalized())>-0.1:
		$Death.play()
		var h: HealthComponent = other.get_node("HealthComponent")
		var active_damage = (damage_base + linear_velocity.length() * damage_speed_mult) 
		h.apply_damage(active_damage, self)
	else:
		$Hit.play()
func _physics_process(_delta: float) -> void:
	var is_moving = linear_velocity.length() > 100.0
	#var playback :AnimationNodeStateMachinePlayback= $AnimationTree.get("parameters/playback")
	if linear_velocity:
		$SpriteOrigin.scale.x = 1.3 if linear_velocity.x>0 else -1.3
	#$AnimationTree.set("parameters/conditions/is_hit",false)
	$AnimationTree.set("parameters/conditions/is_moving",is_moving)
	$AnimationTree.set("parameters/conditions/is_not_moving",!is_moving)
	if is_a_homing_cube and is_moving:
		var closest_dist = INF
		var closest_node = null
		var future_position = global_position + linear_velocity
		for e in get_tree().get_nodes_in_group("enemy"):
			if e.is_in_group("bullet"):
				continue
			if e is Node2D:
				var dist = e.global_position.distance_squared_to(future_position)
				if dist<closest_dist:
					closest_dist = dist
					closest_node = e
		if closest_node:
			var dirr = future_position.direction_to(closest_node.global_position) * mass 
			apply_central_force(dirr)
			var speed = linear_velocity.length()
			var ratio = clamp(speed / 1000.0,0.0,2.0)
			var new_angle = lerp_angle(
				Vector2.RIGHT.angle_to(linear_velocity),
				Vector2.RIGHT.angle_to(dirr),
				_delta*ratio
			)
			linear_velocity = Vector2.RIGHT.rotated(new_angle) * speed
		
	
	
	
