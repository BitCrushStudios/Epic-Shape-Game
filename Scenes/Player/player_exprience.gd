@tool
class_name PlayerExperience
extends EntityComponent
static var instance:PlayerExperience
@export var exp_base = 100.0
@export var exp_current = 0.0
@export var exp_rate = 3.142
@export var score = 0
@export var upgrades: Array[UpgradeResource] = []
signal level_increase(level:int)
signal upgrade_selected(upgrade:UpgradeResource)
@export
var level: int:
	get():
		return calculate_level_from_exp(exp_current)
	set(v):
		exp_current = calculate_exp_from_level(v)+0.01
		
@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY)
var level_exp_min: float:
	get():
		return calculate_exp_from_level(level)

@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY)
var level_exp_max: float:
	get():
		return calculate_exp_from_level(level + 1)
		
@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY)
var level_exp_diff: float:
	get():
		return calculate_exp_from_level(level + 1) - calculate_exp_from_level(level)

func _init():
	instance = self


func calculate_exp_from_level(_level: float):
	return pow(_level+pow(exp_base, 1.0 / exp_rate), exp_rate)

func calculate_level_from_exp(_exp: float):
	return pow(_exp + exp_base , 1.0 / exp_rate) - pow(exp_base, 1.0 / exp_rate)

func apply_exp_gain(exp_gain:float, _source:Node):
	var cur_level = level
	exp_current += exp_gain
	score += exp_gain
	prints(exp_current,"+",exp_gain)
	
	if level>cur_level:
		for i in range(cur_level, level):
			level_increase.emit(i)
			await upgrade_selected

func trigger_level_increase():
	apply_exp_gain(level_exp_max - exp_current+0.01, self)
	

func apply_upgrade_select(resource:UpgradeResource):
	print(resource)
	resource.apply_upgrade()
	upgrades.append(resource)
	upgrade_selected.emit(resource)
