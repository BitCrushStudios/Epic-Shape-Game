@tool
extends Resource
class_name UpgradeResource

@export var texture:Texture2D:
	set(v):
		texture = v
		emit_changed()
		
@export var name:String:
	set(v):
		name = v
		emit_changed()
@export_custom(PROPERTY_HINT_MULTILINE_TEXT,"") 
var description:String:
	set(v):
		description = v
		emit_changed()
@export var apply:Callable = func():
	pass

static func create_speed_upgrade(player:Player,boost = 1):
	var resource = UpgradeResource.new()
	resource.name = "Speed"
	resource.apply = func apply():
		player.move_speed += boost
	return resource
	
	
	
static func create_mass_upgrade(player:Player,boost = 1):
	var resource = UpgradeResource.new()
	resource.name = "Mass"
	resource.apply = func apply():
		player.mass += boost
	return resource
	
	
	
static func create_health_max_upgrade(player:Player,boost = 1):
	var resource = UpgradeResource.new()
	resource.name = "Health"
	resource.apply = func apply():
		player.health_max += boost
	return resource
	

static func create_extra_weapon_upgrade(player:Player,boost = 1):
	var resource = UpgradeResource.new()
	var weapon_count = 0
	for c in player.get_children():
		if c is Weapon:
			weapon_count += 1
	resource.name = "Extra Weapon +1 (%d)" % (weapon_count+1)
	resource.apply = func apply():
		var weapon = preload("res://Game/Weapons/WeaponCube.tscn").instantiate()
		player.add_child(weapon,true)
		var offset = Vector2(randf_range(-30,30),randf_range(-30,30))
		weapon.global_position = player.global_position + offset
	return resource
	

	
	
	
	
