@tool
extends RigidBody2D
class_name Weapon
static var instances : Array[Weapon] = []
signal resource_changed()
signal entered_hurtbox(node:Node)
@export var damage = 1.0
@export var activation_max = 1.0
var speed_damage_mult = 0.01
var max_obstacle_radius = 30.0
var activation_value = 0.0
enum State{
	Normal,Activated
}
@export var state = State.Normal:
	set(v):
		state = v

func _ready():
	entered_hurtbox.connect(_entered_hurtbox)
	
func _entered_hurtbox(node:Node):
	$EnemyHit.pitch_scale = randf_range(0.9,1.3)
	$EnemyHit.play()
	if state != State.Activated:
		return
	if node is Enemy:
		var g1 = global_position
		var g2 = node.global_position
		var c = (g1 + g2)/2.0
		var d1 = (g1 - g2).normalized()
		var d2 = -d1
		node.take_damage(damage + linear_velocity.length() * speed_damage_mult)
		var other_velocity = node.linear_velocity
		apply_impulse(d1.project(linear_velocity) , c)
		node.apply_impulse(d2.project(other_velocity) , c)

	
func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	$NavigationObstacle2D.velocity = linear_velocity
	if (linear_velocity.length()/300.0+absf(angular_velocity)/20.0)>1:
		activation_value=clampf(activation_value+_delta,0,activation_max)
	else:
		activation_value=clampf(activation_value-_delta,0,activation_max)
	var r = clampf(activation_value/(activation_max/4.0),0,1)
	#r = r * r * (3.0 - 2.0 * r)
	%NormalSprite.modulate.a = 1 - r
	%ActivatedSprite.modulate.a = r
	state = State.Activated if activation_value>0 else State.Normal
	
	$NavigationObstacle2D.radius =  max_obstacle_radius if activation_value>0 else 0.0
		
func _on_body_entered(body:Node2D):
	if %ActivatedSprite != null and %ActivatedSprite is AnimatedSprite2D:
		%ActivatedSprite.play("Hit")
	
func _enter_tree() -> void:
	instances.append(self)
	
func _exit_tree() -> void:
	instances.erase(self)
	
