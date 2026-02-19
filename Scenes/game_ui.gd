extends CanvasLayer

func _process(_delta:float):
	if not Player.instance:
		return
	%ProgressBar.max_value = Player.instance.health_max
	%ProgressBar.value = Player.instance.health_current
	print(Player.instance.health_current)
