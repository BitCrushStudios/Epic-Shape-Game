extends Node
class_name PlayerController

func _physics_process(delta: float) -> void:
	var player: Player = get_parent()
	var mvec = Input.get_vector("move_left","move_right","move_up","move_down")
	var desired = player.desired_velocity
	var resource = player.resource
	desired = mvec * player.resource.speed
	desired = desired - player.linear_velocity
	desired = desired.limit_length(resource.speed) / resource.speed
	desired = desired * resource.speed * resource.accel_mult
	player.desired_velocity = desired
	
