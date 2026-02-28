extends Resource
class_name PlayerResource

@export var inventory: Array[ItemResource] = []
@export var weapons: Array[WeaponResource] = []

@export_category("Stats")
@export var stat_size = 1:
	get():
		return stat_size
	set(v):
		stat_size = clampi(v, 1, stat_size_max)
		emit_changed()
@export var stat_size_max = 10

@export var stat_speed = 1:
	get():
		return stat_speed
	set(v):
		stat_speed = clampi(v, 0, stat_speed_max)
@export var stat_speed_max = 10

@export var stat_iframe = 1:
	get():
		return stat_iframe
	set(v):
		stat_iframe = clampi(v, 0, stat_iframe_max)
@export var stat_iframe_max = 10

@export var stat_mass = 1:
	get():
		return stat_mass
	set(v):
		stat_mass = clampi(v, 0, stat_mass_max)
		emit_changed()
@export var stat_mass_max = 10

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
@export var exp_rate = 1.1
@export var money = 1000:
	set(v):
		money = v 
		emit_changed()

@export_category("Stat Result")
@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_NONE) 
var speed: float:
	get():
		return base_speed + (base_speed_add * stat_speed)
@export var experience = 0.0
var exp_level: float:
	get():
		return experience/exp(exp_rate)
