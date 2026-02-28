@tool
extends Control
class_name UpgradeModal 

signal upgrade_selected(upgrade:UpgradeResource)
@export var player:PlayerResource = PlayerResource.new():
	get():
		return player
	set(v):
		if player and player.changed.is_connected(update_player_ui):
			player.changed.disconnect(update_player_ui)
		player = v
		if player:
			player.changed.connect(update_player_ui)
		update_player_ui()
func update_player_ui():
	pass
@export_tool_button("Setup") var __setup = setup_ui
class ChanceArray:
	var pairs = []
	
	func add(value,chance):
		pairs.append([value,chance])
		
	func remove(value):
		for i in range(pairs.size()):
			if pairs[i][0] == value:
				pairs.remove_at(i)
				return
				
	func shuffle():
		pairs.shuffle()
	func total():
		var max_chance = 0.0
		for pair in pairs:
			max_chance += pair[1]
		return max_chance
	func accumulated():
		var acc = []
		var n = 0.0
		for pair in pairs:
			acc.append([pair[0],n])
			n+=pair[1]
		return acc
	func random_index():
		var q = randf_range(0, total())
		var n = 0.0
		for i in range(pairs.size()):
			if n>q:
				return i-1
			n+=pairs[i][1]
		return pairs.size()-1
		
	func random():
		var i = random_index()
		if i == -1:
			return pairs[i][0]
		return null
		
	func take():
		var i = random_index()
		if i == -1:
			return pairs.pop_at(i)[0]
		return null
	func size():
		return pairs.size()
			
			
			
	
func setup_ui():
	var upgrades = UpgradeResource.get_available_upgrades()
	var randArr = ChanceArray.new()
	for upg in upgrades:
		randArr.add(upg,upg.poll(player))
	randArr.shuffle()
	for btn in get_buttons():
		if randArr.size()<=0:
			btn.hide()
			continue
		btn.show()
		
		var upg = randArr.take()
		btn.resource = upg
	
func modal():
	setup_ui()
	
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
		
		
		
	
