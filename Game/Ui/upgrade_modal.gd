extends Control
class_name UpgradeModal 

signal upgrade_selected(upgrade:UpgradeResource)

func wait_for_selection():
	var up = await upgrade_selected
	$AnimationPlayer.play("close")
	await $AnimationPlayer.animation_finished
	
