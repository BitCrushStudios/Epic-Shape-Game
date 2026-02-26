@tool
extends RigidBody2D
class_name Weapon

@export var resource: WeaponResource:
	set(v):
		if resource:
			resource.changed.disconnect(_resource_changed)
		resource = v
		if resource:
			resource.changed.connect(_resource_changed)
var max_obstacle_radius = 30.0
var activation_value = 0.0
enum State{
	Normal,Activated
}
@export var state = State.Normal:
	set(v):
		state = v

func _resource_changed():
	%NormalSprite.texture = resource.normal_texture
	%ActivatedSprite.texture = resource.activated_texture
func _ready():
	body_entered.connect(_on_body_entered)
	
func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	$NavigationObstacle2D.velocity = linear_velocity
	if (linear_velocity.length()/300.0+absf(angular_velocity)/20.0)>1:
		activation_value=clampf(activation_value+_delta,0,resource.activation_max)
	else:
		activation_value=clampf(activation_value-_delta,0,resource.activation_max)
	var r = clampf(activation_value/(resource.activation_max/4.0),0,1)
	#r = r * r * (3.0 - 2.0 * r)
	%NormalSprite.modulate.a = 1 - r
	%ActivatedSprite.modulate.a = r
	state = State.Activated if activation_value>0 else State.Normal
	
	$NavigationObstacle2D.radius =  max_obstacle_radius if activation_value>0 else 0.0
		
func _on_body_entered(body:Node2D):
	if state != State.Activated:
		return
	if body is RigidBody2D:
		if body is Enemy:
			body.apply_damage(resource.damage)
	$Hit.pitch_scale = randf_range(0.95, 1.15)
	$Hit.play()
	
