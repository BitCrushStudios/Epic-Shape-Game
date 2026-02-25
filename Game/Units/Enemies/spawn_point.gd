extends Node2D
class_name SpawnPoint 

@export var tscn:PackedScene
@export var spawn_time = 3.0

func _process(delta: float) -> void:
	spawn_time -= delta
	if spawn_time<=0:
		var node:Enemy = tscn.instantiate()
		add_sibling(node,true)
		node.global_position = global_position
		queue_free()
