extends Node2D
class_name SpawnPoint 

@export var tscn:PackedScene
@export var spawn_time = 2.2

func _process(delta: float) -> void:
	spawn_time -= delta
	if spawn_time<=0:
		var node:Enemy = tscn.instantiate()
		add_sibling(node,true)
		node.global_position = global_position
		await get_tree().create_timer(0.5)
		queue_free()
