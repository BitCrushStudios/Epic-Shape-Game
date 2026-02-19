extends Unit
class_name Player

var move_speed = 500.0
var move_accel = move_speed *2.0
static var instance:Player
var iframe_max = 1.0
var iframe = 0.0
signal iframe_elapse()
func apply_damage(damage:float):
	if iframe<=0:
		super(damage)
		
func _recieved_damage(_damage:float):
	%AnimationPlayer.play("damage")
	iframe = iframe_max
	await iframe_elapse
	%AnimationPlayer.stop()
			

func _ready():
	Player.instance = self
	recieved_damage.connect(_recieved_damage)

func _physics_process(delta: float) -> void:
	if iframe>0:
		iframe = iframe - delta
		if iframe<=0:
			iframe_elapse.emit()
	var mvec = Input.get_vector("move_left","move_right","move_up","move_down")
	var desired_velocity = (mvec * move_speed - linear_velocity).limit_length(move_speed)/move_speed * move_accel
	apply_central_force(desired_velocity * mass)
	super(delta)
