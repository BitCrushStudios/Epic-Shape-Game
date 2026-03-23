@tool
extends Node
class_name WeaponsManager

signal weapons_changed()
@export var weapons: Array[Weapon] = []:
	set(v):
		for w in weapons:
			w.resource_changed.disconnect(weapons_changed.emit)
		weapons = v
		for w in weapons:
			w.resource_changed.connect(weapons_changed.emit)
		weapons_changed.emit()
func add_weapon(weapon:Weapon):
	var rand_point = NavigationServer2D.map_get_random_point(get_viewport().world_2d.navigation_map,2,true)
	weapon.global_position = rand_point
	add_child(weapon)
	await get_tree().process_frame
	weapon.global_position = rand_point
			
		
	
func dev_add_weapon():
	var node:Weapon = preload("res://Game/Weapons/CubeWeapon.tscn").instantiate()
	add_weapon(node)
func dev_remove_weapon():
	if get_child_count(true)>0:
		remove_child(get_child(0,true))
func clear_weapons():
	for c in get_children(true):
		remove_child(c)
		c.free()
	weapons = []
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_1:
				clear_weapons()
				add_weapon(load("res://Game/Weapons/CubeWeapon.tscn").instantiate())
			if event.keycode == KEY_2:
				clear_weapons()
				add_weapon(load("res://Game/Weapons/CircleWeapon.tscn").instantiate())
			if event.keycode == KEY_3:
				clear_weapons()
				add_weapon(load("res://Game/Weapons/DvdLogoWeapon.tscn").instantiate())
			if event.keycode == KEY_4:
				clear_weapons()
				add_weapon(load("res://Game/Weapons/GolfBallWeapon.tscn").instantiate())
	
