extends Area2D

func _ready() -> void:
	body_entered.connect(_body_entered)
	
func _body_entered(body:RigidBody2D):
	if body is GoldPiece:
		body.queue_free()
