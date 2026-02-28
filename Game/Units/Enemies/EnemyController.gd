extends NavigationAgent2D

@onready var enemy:Enemy = get_parent()
var time_rate = 0.5
@onready var time_current = time_rate

func _ready():
	velocity_computed.connect(_velocity_computed)
	enemy.health_depleted.connect(_health_depleted)
	
func _health_depleted():
	queue_free()

func _process(delta:float):
	velocity = enemy.global_position.direction_to(get_next_path_position()) * max_speed
	if not Player.instance:
		return
	time_current+=delta
	if time_current>time_rate:
		time_current = randf()*time_rate
		target_position = Player.instance.global_position
		pass
	
func _velocity_computed(safe_velocity:Vector2):
	enemy.apply_force((safe_velocity ) * enemy.mass)
