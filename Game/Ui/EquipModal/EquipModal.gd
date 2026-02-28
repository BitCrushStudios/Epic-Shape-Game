@tool
extends Control
class_name EquipModal

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
@export var weapons: Array[WeaponResource] = []:
	set(v):
		weapons = v
		update_weapons_ui()
		
@export var weapon_index: int:
	set(v):
		weapon_index = v
		update_items_ui()
@export var active_weapon:WeaponResource:
	get():
		if weapon_index<weapons.size():
			return weapons[weapon_index]
		return null

func update_weapons_ui():
	if not is_inside_tree():
		await tree_entered
	for c in %WeaponItems.get_children(true):
		c.queue_free.call_deferred()
	for resource in weapons:
		var btn:EquipWeaponButton = preload("res://Game/Ui/EquipModal/EquipWeaponButton.tscn").instantiate()
		btn.resource = resource
		%WeaponItems.add_child(btn, true, Node.INTERNAL_MODE_FRONT)
		btn.pressed.connect(weapon_selected.bindv([btn]))
	update_items_ui()
	
func weapon_selected(btn:EquipWeaponButton):
	if not is_inside_tree():
		await tree_entered
	for c in %WeaponItems.get_children(true):
		(c as Button).button_pressed = false 
	weapon_index = btn.get_index(true)
	
func update_player_ui():
	if not is_inside_tree():
		await tree_entered
	
	for c in %PlayerInvItems.get_children(true):
		c.queue_free.call_deferred()
	for item in player.inventory:
		var btn: EquipItemButton = preload("res://Game/Ui/EquipModal/EquipItemButton.tscn").instantiate()
		btn.resource = item
		%PlayerInvItems.add_child(btn, true, Node.INTERNAL_MODE_FRONT)
		btn.pressed.connect(player_inv_btn_pressed.bind(btn))

func player_inv_btn_pressed(btn:EquipItemButton):
	if not active_weapon:
		return
	player.inventory.erase(btn.resource)
	active_weapon.items.append(btn.resource)
	
	player = player
	weapons = weapons
	
func weapon_inv_btn_pressed(btn:EquipItemButton):
	if not active_weapon:
		return
	player.inventory.append(btn.resource)
	active_weapon.items.erase(btn.resource)
	
	player = player
	weapons = weapons
	
	
func update_items_ui():
	if not is_inside_tree():
		await tree_entered
	if weapon_index < %WeaponItems.get_child_count(true):
		(%WeaponItems.get_child(weapon_index,true) as EquipWeaponButton).button_pressed = true
	for c in %WeaponInvItems.get_children(true):
		c.queue_free.call_deferred()
	if weapon_index < weapons.size() and weapons[weapon_index]:
		var weapon = weapons[weapon_index]
		for resource in weapon.items:
			var btn:EquipItemButton = preload("res://Game/Ui/EquipModal/EquipItemButton.tscn").instantiate()
			btn.resource = resource
			%WeaponInvItems.add_child(btn, true, Node.INTERNAL_MODE_FRONT)
			btn.pressed.connect(weapon_inv_btn_pressed.bind(btn))
	
@export_tool_button("Update") var _setup = setup_ui
func setup_ui():
	update_weapons_ui()
	update_player_ui()
	
func modal():
	setup_ui()
	$AnimationPlayer.play("open")
	await %AcceptButton.pressed
	$AnimationPlayer.play("close")
	await $AnimationPlayer.animation_finished
func _ready():
	#for btn in get_buttons():
		#btn.item_selected.connect(item_selected.emit)
	#item_selected.connect(_item_selected)
	if get_tree().current_scene == self:
		await modal()
