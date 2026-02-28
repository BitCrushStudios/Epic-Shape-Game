@tool
extends Resource
class_name PlayerResource

@export var inventory: Array[ItemResource] = []:
	get():
		return inventory
	set(v):
		inventory = v
		emit_changed()
@export var weapons: Array[WeaponResource] = []:
	get():
		return weapons
	set(v):
		weapons = v
		weapons_changed.emit()
		emit_changed()
signal weapons_changed()

	
@export_category("Stats")
@export var stat_size = 1:

	set(v):
		stat_size = clampi(v, 1, stat_size_max)
		emit_changed()
@export var stat_size_max = 10

@export var stat_speed = 1:
	set(v):
		stat_speed = clampi(v, 0, stat_speed_max)
@export var stat_speed_max = 10

@export var stat_iframe = 1:
	set(v):
		stat_iframe = clampi(v, 0, stat_iframe_max)
@export var stat_iframe_max = 10

@export var stat_mass = 1:
	set(v):
		stat_mass = clampi(v, 0, stat_mass_max)
		emit_changed()
@export var stat_mass_max = 10

@export var stat_health = 1:
	set(v):
		stat_health = clampi(v, 0, stat_health_max)
		emit_changed()
@export var stat_health_max = 10

@export_category("Stats Base")
@export var base_mass = 10.0:
	set(v):
		base_mass = v
		emit_changed()
@export var base_mass_add = 1.0:
	set(v):
		base_mass_add = v
		emit_changed()
@export var base_speed = 500.0
@export var base_speed_add = 100.0
@export var base_size = 1.0
@export var base_size_add = 0.1
@export var accel_mult = 10.0
@export var exp_rate = 4.0
@export var current_wave:int:
	set(v):
		current_wave = v
		emit_changed()
@export var money = 1000:
	set(v):
		money = v 
		emit_changed()

@export_category("Stat Result")
@export
var speed: float:
	get():
		return base_speed + (base_speed_add * stat_speed)

@export_category("Experience")
func calc_level_from_exp(v:float):
	return pow(v, 1.0 / exp_rate)
func calc_exp_from_level(level:int):
	return pow(level, exp_rate) 
func exp_add(v:float):
	var last_level = current_level
	experience += v
	levels_gained += (current_level - current_level)
var levels_gained = 0
@export var experience = 0.0:
	set(v):
		experience = v
		emit_changed()
@export var current_level: int:
	get():
		return calc_level_from_exp(experience)
	set(v):
		experience = calc_exp_from_level(v+0.001)
	
@export
var current_level_exp_required: float:
	get():
		return calc_exp_from_level(current_level)
		
@export
var next_level_exp_required: float:
	get():
		return calc_exp_from_level(current_level+1)

@export var exp_required:float:
	get():
		return next_level_exp_required - current_level_exp_required
