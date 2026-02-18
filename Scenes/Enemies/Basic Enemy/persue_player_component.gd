extends EntityComponent
class_name PersuePlayerComponent

@export var speed = 2000.0
@onready var entity: RigidBody2D = get_parent()
@export var flip_direction = Vector2.RIGHT

func _physics_process(_delta: float):
	if not Player.instance:
		return
	var pos_diff = (Player.instance.global_position) - entity.global_position
	entity.apply_central_force(pos_diff.normalized() * speed - entity.linear_velocity)
	
