extends Unit
class_name Enemy


@export var agent:NavigationAgent2D
@onready var target_position = global_position 
var update_target_position_rate = 0.1
var update_target_position_time = 0.0
