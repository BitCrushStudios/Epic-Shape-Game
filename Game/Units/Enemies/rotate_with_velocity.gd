extends Node

@export var target:Node2D
@export var source:RigidBody2D


func _physics_process(_delta: float) -> void:
	if source.linear_velocity:
		target.rotation = Vector2.RIGHT.angle_to(source.linear_velocity.normalized())
