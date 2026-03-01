@tool
extends Control
class_name UpgradeModal 


class ChanceArray:
	var pairs = []
	
	func add(value,chance):
		pairs.append([value,chance])
	
	func shuffle():
		pairs.shuffle()
		
	func total():
		var _total = 0.0
		for pair in pairs:
			_total += pair[1]
		return _total
		
	func accumulated():
		var acc = []
		var n = 0.0
		for pair in pairs:
			acc.append([pair[0],n])
			n+=pair[1]
		return acc
		
	func random_index():
		var t = total()
		var q = randf_range(0, t)
		var n1 = 0.0
		var n2:float
		for i in range(pairs.size()):
			n2 = n1 + pairs[i][1]
			if q>n1 and q < n2:
				return i
			n1 = n2
		return pairs.size()-1
		
		
	func take():
		var i = random_index()
		if i != -1:
			return pairs.pop_at(i)[0]
		return null
		
	func size():
		return pairs.size()
			
			
			
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
	
@export var upgrades: Array[UpgradeResource] = []:
	get():
		return upgrades
	set(v):
		upgrades = v
		update_upgrades_ui()
		
func update_upgrades_ui():
	if not is_inside_tree():
		await tree_entered
	var btns: Array[UpgradeButton] = get_buttons()
	
	for i in range(min(btns.size(),upgrades.size())):
		var p:Control = btns[i].get_parent().get_parent()
		if i < upgrades.size():
			btns[i].resource = upgrades[i]
			p.visible = upgrades[i] != null
		else:
			btns[i].resource = null
			p.visible = false
func randomize():
	if not is_inside_tree():
		await tree_entered
	var available = UpgradeResource.get_available_upgrades()
	var randArr = ChanceArray.new()
	for upg in available:
		randArr.add(upg, upg.poll(player))
	randArr.shuffle()
	var btns: Array[UpgradeButton] = get_buttons()
	var arr:Array[UpgradeResource] = []
	arr.resize(btns.size())
	for i in range(btns.size()):
		if randArr.size()>0:
			var upg = randArr.take().new()
			arr.set(i, upg)
	upgrades = arr
	

func setup_ui():
	if not is_inside_tree():
		await tree_entered
	randomize()
@export_tool_button("Setup") var _randomize_action = randomize

func apply_upgrade(upgrade:UpgradeResource):
	upgrade.apply(player)
	
func modal(turns=1):
	assert(turns>=1)
	if not is_inside_tree():
		await tree_entered
	setup_ui()
	
	var upgrades:Array[UpgradeResource] = []
	var u:UpgradeResource
	$AnimationPlayer.play("open")
	#await $AnimationPlayer.animation_finished
	for i in range(turns,1,-1):
		u = await upgrade_selected
		upgrades.append(u)
		apply_upgrade(u)
		$CardsContainer/AnimationPlayer.play("close")
		await $CardsContainer/AnimationPlayer.animation_finished
		$CardsContainer/AnimationPlayer.play("open")
		#await $CardsContainer/AnimationPlayer.animation_finished
		
	u = await upgrade_selected
	upgrades.append(u)
	apply_upgrade(u)
	$AnimationPlayer.play("close")
	await $AnimationPlayer.animation_finished
		
	
	
func get_buttons() -> Array[UpgradeButton]:
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
	if get_tree().current_scene == self:
		await modal(4)
	
