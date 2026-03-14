@tool 
extends RigidBody2D
class_name Enemy



var iframe = 0.0
var iframe_max = 0.5
signal entered_hurtbox(node:Node)
signal took_damage(damage:float)
signal health_depleted()
signal health_changed()

@export var agent:NavigationAgent2D
@onready var target_position = global_position 
var update_target_position_rate = 2.0
var update_target_position_time = 0.0
@export var experience_on_death = 1.0
@export var damage = 1.0
@export var health_max = 1.0
@onready var health_current=health_max:
	set(v):
		health_current = v
		health_changed.emit()

func take_damage(damage:float):
	health_current -= damage
	took_damage.emit(damage)
	if health_current<=0.0:
		health_depleted.emit()
	

func _ready():
	z_index = 0
	took_damage.connect(_recieved_damage)
	health_depleted.connect(_health_depleted)
	entered_hurtbox.connect(_entered_hurtbox)
func _entered_hurtbox(node:Node):
	if iframe>0.0:
		return
	if node is Player:
		node.resource.take_damage(damage)
		iframe = iframe_max
		#$Hit.pitch_scale = randf_range(0.9, 1.3)
		#$Hit.play()

func _enter_tree() -> void:
	get_tree().emit_signal("enemy_added",self)
	
func _exit_tree() -> void:
	get_tree().emit_signal("enemy_removed",self)
	
#func _on_death():
	#Player.instance.resource.exp_add(experience_on_death)

func _body_entered(other:Node2D):
	if other is Player:
		other.resource.take_damage(damage)
func _physics_process(_delta: float) -> void:
	apply_torque(-rotation_degrees * 1000.0 * mass)
	for other in get_colliding_bodies():
		_body_entered(other)
func _recieved_damage(_damage:float):
	if %Animation != null:
		%Animation.play("damage")
	_particle_create(preload("./DamageParticles.tscn").instantiate())
	
func spawn_coins():
	var amount  = randf_range(1,5)
	await get_tree().process_frame
	for i in range(amount):
		var gp:GoldPiece = preload("res://Game/Gold/GoldPiece.tscn").instantiate()
		get_tree().current_scene.add_child(gp)
		gp.global_position = global_position
		gp.apply_central_impulse((Vector2.RIGHT*300.0).rotated(TAU*randf()))
		await get_tree().process_frame
		
func _health_depleted():
	spawn_coins()
	collision_mask = 0
	collision_layer = 0
	z_index = -1
	took_damage.disconnect(_recieved_damage)
	health_depleted.disconnect(_health_depleted)
	if %Animation != null:
		%Animation.play("death")
	if $Death != null:
		$Death.play()
		$Death.volume_db = randf_range(-2,0)
		$Death.pitch_scale = randf_range(1.2,1.5)
	await _particle_create(preload("./DeathParticles.tscn").instantiate())
	queue_free()
		
	
func _particle_create(particles:GPUParticles2D):
	add_child(particles,true,INTERNAL_MODE_FRONT)
	particles.one_shot = true
	particles.emitting = true
	await particles.finished
	particles.queue_free()

func _process(delta: float) -> void:
	iframe = max(iframe-delta, 0.0)
	
		
		
