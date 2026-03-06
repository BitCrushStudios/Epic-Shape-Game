@tool
extends RigidBody2D
class_name GoldPiece

var random_size_range = [0.44, 0.55]
func randomize_size():
	$Sprite2D.scale = (Vector2.ONE * randf_range(
		random_size_range[0],
		random_size_range[1]
	))
	$Sprite2D.modulate = Color.from_hsv(
		0, randf_range(0.00,0.20), randf_range(0.75,1.00)
	)
@export_tool_button("Randomize Size") var _randomize_size_action = randomize_size

func _ready() -> void:
	randomize_size()
	
func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if not Player.instance:
		return
	var desired = (
		Player.instance.global_position - 
		(global_position)
	)
	var radius = 100.0
	if desired.length()<radius:
		z_index = 1
		desired = ((desired.normalized() * 20000.0 * clamp(1.5 - desired.length()/radius, 0.0, 1.0)) - linear_velocity*20.0)
		apply_central_force(desired*mass)
	else:
		z_index = -1
