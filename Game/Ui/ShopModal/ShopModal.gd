@tool
extends Control
class_name ShopModal 

signal item_selected(item:ItemResource)
	
	
func get_buttons() -> Array[ShopButton]:
	return [
		%ShopButton1,
		%ShopButton2,
		%ShopButton3,
		%ShopButton4,
		%ShopButton5,
	]

@export_tool_button("Setup") var __setup = setup
func setup():
	var available_items = ItemResource.get_available_items()
	for btn in get_buttons():
		if available_items.size()<=0:
			btn.hide()
			continue
		btn.show()
		var i = randi_range(0,available_items.size()-1)
		btn.resource = available_items.pop_at(i).new()
	
func modal():
	setup()
	$AnimationPlayer.play("open")
	await %AcceptButton.pressed
	$AnimationPlayer.play("close")
	await $AnimationPlayer.animation_finished

func _ready():
	for btn in get_buttons():
		btn.item_selected.connect(item_selected.emit)
	if get_tree().root == self:
		await modal()
