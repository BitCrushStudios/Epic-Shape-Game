@tool
extends Control
class_name UpgradeModal 

signal upgrade_selected(upgrade:UpgradeResource)
@export_tool_button("Setup") var __setup = modal
func modal():
	var available_upgrades = UpgradeResource.get_available_upgrades()
	for btn in get_buttons():
		if available_upgrades.size()<=0:
			btn.hide()
			continue
		btn.show()
		var i = randi_range(0,available_upgrades.size()-1)
		btn.resource = available_upgrades.pop_at(i).new()
		
	$AnimationPlayer.play("open")
	
	var upgrade = await upgrade_selected
	
	$AnimationPlayer.play("close")
	await $AnimationPlayer.animation_finished
	
	return upgrade
func get_buttons():
	return [
		%UpgradeButton1,
		%UpgradeButton2,
		%UpgradeButton3,
		%UpgradeButton4,
		%UpgradeButton5,
	]
	

func _ready() -> void:
	for btn in get_buttons():
		btn.upgrade_selected.connect(upgrade_selected.emit.call)
	
