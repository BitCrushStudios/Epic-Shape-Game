extends Node

func _process(_delta:float):
	if not Player.instance:
		return
	%PlayerVelocity.text = "%.2f" % Player.instance.linear_velocity.length()
	%PlayerHealth.text = "%.2f" % Player.instance.health_current
	%PlayerExperience.text = "%d" % Player.instance.experience
	%PlayerLevel.text = "%d" % Player.instance.exp_level
