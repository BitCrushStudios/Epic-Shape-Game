extends NavigationAgent2D

@onready var enemy:Enemy = get_parent()
var time_rate = 1.0
@onready var time_current = time_rate

func _ready():
	velocity_computed.connect(_velocity_computed)
	#target_position = enemy.global_position
	target_position = Player.instance.global_position
	enemy.health_depleted.connect(_health_depleted)
func _health_depleted():
	process_mode = Node.PROCESS_MODE_DISABLED
	velocity_computed.disconnect(_velocity_computed)

func _process(delta:float):
	velocity = enemy.global_position.direction_to(get_next_path_position()) * max_speed
	if not Player.instance:
		return
	time_current+=delta
	if time_current>time_rate:
		time_current = 0.0
		target_position = Player.instance.global_position
		pass
	
func _velocity_computed(safe_velocity:Vector2):
	print("safe",safe_velocity)
	enemy.apply_force((safe_velocity - enemy.linear_velocity) * enemy.mass)
