@tool
extends RigidBody2D
class_name Weapon

@export var damage = 1.0
var max_obstacle_radius = 30.0
var activation_value = 0.0
var activation_max = 1.0
enum State{
	Normal,Activated
}
@export var state = State.Normal:
	set(v):
		state = v
		if not is_inside_tree():
			await tree_entered
		var r = 0.5
		var t = create_tween()
		var c = Color.WHITE if state == State.Normal else Color.TRANSPARENT
		t.tween_property(%NormalSprite,"modulate", c, r)
		t = create_tween()
		c = Color.WHITE if state == State.Activated else Color.TRANSPARENT
		t.tween_property(%ActivatedSprite,"modulate", c, r)
		
func _ready():
	body_entered.connect(_on_body_entered)
	
func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	$NavigationObstacle2D.velocity = linear_velocity
	if (linear_velocity.length()+angular_velocity)/300.0>1:
		activation_value=clampf(activation_value+_delta,0,activation_max)
	else:
		activation_value=clampf(activation_value-_delta,0,activation_max)
	
	state = State.Activated if activation_value>0 else State.Normal
		
	$NavigationObstacle2D.radius =  max_obstacle_radius if activation_value>0 else 0.0
		
func _on_body_entered(body:Node2D):
	if state != State.Activated:
		return
	if body is RigidBody2D:
		if body is Enemy:
			body.apply_damage( damage)
	$Hit.play()
	
