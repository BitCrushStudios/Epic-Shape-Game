@tool
extends Control
class_name UpgradeModal 

signal upgrade_selected(upgrade:UpgradeResource)
@export var player:PlayerResource
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
	setup()
	
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
	if get_tree().root == self:
		await get_tree().process_frame
		await modal()
	
func _process(_delta:float):
	if Engine.is_editor_hint():
		return
	var mpos = get_global_mouse_position()
	for btn in get_buttons():
		var p = btn.get_parent()
		p.scale = (Vector2.ONE - 
			(
				(p.get_global_rect().get_center() - mpos)
				.limit_length(3000.0)
				/3000.0
			)
			.abs()
		).clampf(0.8,1.0)
		
		
		
	
