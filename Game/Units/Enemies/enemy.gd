extends Unit
class_name Enemy


@export var agent:NavigationAgent2D
@onready var target_position = global_position 
var update_target_position_rate = 2.0
var update_target_position_time = 0.0
@export var experience_on_death = 1.0

func _ready() -> void:
	health_depleted.connect(_on_death)
	
func _on_death():
	Player.instance.resource.experience += experience_on_death
