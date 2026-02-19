extends Unit
class_name Player

var move_speed = 500.0
var move_accel = move_speed *2.0
static var instance:Player
func _ready():
	Player.instance = self

func _physics_process(delta: float) -> void:
	var mvec = Input.get_vector("move_left","move_right","move_up","move_down")
	var desired_velocity = (mvec * move_speed - linear_velocity).limit_length(move_speed)/move_speed * move_accel
	apply_central_force(desired_velocity * mass)
	super(delta)
