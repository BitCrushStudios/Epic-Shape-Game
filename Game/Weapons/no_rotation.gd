extends Node

func _process(_delta):
	(get_parent() as Node2D).global_rotation = 0.0
	
