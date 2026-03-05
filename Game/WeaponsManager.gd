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
		
func dev_add_weapon():
	var node:Weapon = preload("res://Game/Weapons/CubeWeapon.tscn").instantiate()
	add_child(node)
	var map_rid = get_viewport().world_2d.navigation_map
	var rand_point = NavigationServer2D.map_get_random_point(map_rid,1,false)
	node.global_position = rand_point
func dev_remove_weapon():
	if get_child_count(true)>0:
		remove_child(get_child(0,true))
