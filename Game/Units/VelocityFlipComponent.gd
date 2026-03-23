extends Node

@export var body: RigidBody2D
var tween:Tween
var direction = 1
func _process(delta: float) -> void:
	$"../ShadowOrigin/Shadow".scale = Vector2(0.7,0.7)
	var node:Node2D = get_parent()
	if direction != node.scale.x and tween:
		tween.stop()
		tween = null
	direction = 1 if body.linear_velocity.x>=0 else -1
	if direction!=node.scale.x:
		tween = create_tween()
		tween.tween_property(node,"scale", Vector2(direction, 1), 0.05)
	
