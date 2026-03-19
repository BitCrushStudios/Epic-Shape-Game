@tool
extends Resource
class_name PlayerResource


var inventory: Array[ItemResource] = []:
	get():
		return inventory
	set(v):
		inventory = v
		emit_changed()
		
	
@export_category("Stats")

var stat_size = 1:
	set(v):
		stat_size = clampi(v, 1, stat_size_max)
		emit_changed()

var stat_size_max = 10


var stat_speed = 1:
	set(v):
		stat_speed = clampi(v, 0, stat_speed_max)

var stat_speed_max = 10


var stat_iframe = 1:
	set(v):
		stat_iframe = clampi(v, 0, stat_iframe_max)

var stat_iframe_max = 10


var stat_mass = 1:
	set(v):
		stat_mass = clampi(v, 0, stat_mass_max)
		emit_changed()

var stat_mass_max = 10

var stat_weapon_max = 10

var stat_health = 1:
	set(v):
		stat_health = clampi(v, 0, stat_health_max)
		emit_changed()

var stat_health_max = 10

var health_max:float:
	get():
		return base_heath + max(0,stat_health-1) * base_health_add

var health_current: float = 1.0:
	set(v):
		if v<=0:
			health_depleted.emit()
		health_current = v
		emit_changed()
		health_changed.emit()

signal health_changed()
signal took_damage(damage:float)
signal health_depleted()
func reset_health():
	health_current = health_max
func deplete_health():
	health_current = 0
func take_damage(damage:float):
	if iframe_current>0:
		return
	health_current -= damage
	took_damage.emit(damage)
	iframe_trigger()
	
@export_category("Stats Base")

var base_mass = 10.0:
	set(v):
		base_mass = v
		emit_changed()
		

var base_mass_add = 1.0:
	set(v):
		base_mass_add = v
		emit_changed()
		

var base_speed = 500.0:
	set(v):
		base_speed = v
		emit_changed()

var base_heath = 10.0:
	set(v):
		base_heath = v
		emit_changed()
#

var base_health_add = 1.0:
	set(v):
		base_health_add = v
		emit_changed()

var base_speed_add = 100.0:
	set(v):
		base_speed_add = v
		emit_changed()
		

var base_size = 1.0:
	set(v):
		base_size = v
		emit_changed()
		

var base_size_add = 0.1:
	set(v):
		base_size_add = v
		emit_changed()
		

var accel_mult = 10.0:
	set(v):
		accel_mult = v
		emit_changed()
		

var exp_rate = 2.0:
	set(v):
		exp_rate = v
		emit_changed()
		

var money = 0:
	set(v):
		money = v 
		emit_changed()
		
@export_category("Stat Result")
@export
var speed: float:
	get():
		return base_speed + (base_speed_add * stat_speed)
		
@export_category("Experience")
signal level_changed()
func calc_level_from_exp(v:float):
	return pow(v, 1.0 / exp_rate)
func calc_exp_from_level(level:int):
	return pow(level, exp_rate) 
func exp_add(v:float):
	var last_level = current_level
	experience += v
	var level_diff = (current_level - last_level)
	if level_diff!=0:
		levels_gained += level_diff
		level_changed.emit()

var levels_gained = 0:
	set(v):
		levels_gained = v 
		emit_changed()
func clear_levels_gained():
	levels_gained = 0

var experience = 0.0:
	set(v):
		experience = v
		emit_changed()

var current_level: int:
	get():
		return calc_level_from_exp(experience)
	set(v):
		experience = calc_exp_from_level(v+0.001)
	

var current_level_exp_required: float:
	get():
		return calc_exp_from_level(current_level)
		

var next_level_exp_required: float:
	get():
		return calc_exp_from_level(current_level+1)


var exp_required:float:
	get():
		return next_level_exp_required - current_level_exp_required

signal iframe_elapsed()
signal iframe_triggered()

var iframe_max = 0.5

var iframe_current = 0.0:
	set(v):
		iframe_current = v
		emit_changed()
func update_iframe(delta:float):
	if iframe_current>0:
		iframe_current-=delta
		if iframe_current<0:
			iframe_elapsed.emit()
func iframe_trigger():
	iframe_current = iframe_max
	iframe_triggered.emit()
	
