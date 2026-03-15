@tool
extends RigidBody2D
class_name Weapon
static var instances : Array[Weapon] = []
signal resource_changed()
signal entered_hurtbox(node:Node)
@export var resource: WeaponResource:
	get():
		return resource
	set(v):
		if resource:
			resource.changed.disconnect(resource_changed.emit)
		resource = v
		if resource:
			resource.changed.connect(resource_changed.emit)
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
	$CollisionShape2D.shape = resource.shape
func _ready():
	resource_changed.connect(_resource_changed)
	entered_hurtbox.connect(_entered_hurtbox)
	
func _entered_hurtbox(node:Node):
	$EnemyHit.pitch_scale = randf_range(0.9,1.3)
	$EnemyHit.play()
	if state != State.Activated:
		return
	if node is Enemy:
		var g1 = global_position
		var g2 = node.global_position
		var d1 = (g1 - g2).normalized() * 200.0 
		var d2 = -d1
		apply_central_impulse(d1 * mass)
		node.apply_central_impulse(d2 * node.mass)
		node.take_damage(resource.damage)

	
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
	if %ActivatedSprite != null:
		%ActivatedSprite.play("Hit")
	
func _enter_tree() -> void:
	instances.append(self)
	
func _exit_tree() -> void:
	instances.erase(self)
	
