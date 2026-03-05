extends Area2D


func _ready():
	body_entered.connect(_body_entered)

func _body_entered(body:Node):
	if body.has_signal("entered_hurtbox"):
		body.emit_signal("entered_hurtbox",get_parent())
