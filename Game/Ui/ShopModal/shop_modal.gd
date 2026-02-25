@tool
extends Control
class_name ShopModal 


@export_tool_button("Setup") var __setup = setup
func setup():
	var available_upgrades = UpgradeResource.get_available_upgrades()
	for btn in get_buttons():
		if available_upgrades.size()<=0:
			btn.hide()
			continue
		btn.show()
		var i = randi_range(0,available_upgrades.size()-1)
		btn.resource = available_upgrades.pop_at(i).new()
	
func modal():
	$AnimationPlayer.play("open")
	setup()
	$AnimationPlayer.play("close")
	await $AnimationPlayer.animation_finished
	
func get_buttons():
	return [
		%ShopButton1,
		%ShopButton2,
		%ShopButton3,
		%ShopButton4,
		%ShopButton5,
	]
	

func _ready() -> void:
	pass
	
