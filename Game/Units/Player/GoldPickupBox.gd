extends Area2D

func _ready() -> void:
	body_entered.connect(_body_entered)
	
func _body_entered(body:RigidBody2D):
	if body is GoldPiece:
		(get_parent() as Player).resource.money += 1
		body.queue_free()
		$Pickup.pitch_scale = randf_range(0.1,1)
		$Pickup.play()
