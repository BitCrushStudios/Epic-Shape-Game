extends Node

@export var target:Node2D
@export var source:RigidBody2D


func _physics_process(_delta: float) -> void:
	if source.linear_velocity:
		target.scale.x = 1 if source.linear_velocity.x >= 0 else -1
