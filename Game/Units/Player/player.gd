@tool
extends RigidBody2D
class_name Player
static var instance:Player
signal health_depleted()
signal resource_changed()
signal iframe_triggered()
@export var resource: PlayerResource:
	set(v):
		if resource and resource.changed.is_connected(resource_changed.emit):
			resource.changed.disconnect(resource_changed.emit)
		if resource and resource.health_depleted.is_connected(health_depleted.emit):
			resource.health_depleted.disconnect(health_depleted.emit)
		if resource and resource.iframe_triggered.is_connected(iframe_triggered.emit):
			resource.iframe_triggered.disconnect(iframe_triggered.emit)
		resource = v
		if resource:
			resource.changed.connect(resource_changed.emit)
			resource.health_depleted.connect(health_depleted.emit)
			resource.iframe_triggered.connect(iframe_triggered.emit)
		resource_changed.emit()
signal weapons_changed()
@export var weaponsManager:WeaponsManager:
	set(v):
		if weaponsManager and weaponsManager.weapons_changed.is_connected(weapons_changed.emit):
			weaponsManager.weapons_changed.disconnect(weapons_changed.emit)
		weaponsManager = v
		if weaponsManager:
			weaponsManager.weapons_changed.connect(weapons_changed.emit)
		weapons_changed.emit()
var size_tween:Tween

func _update_size():
	if size_tween:
		size_tween.kill()
	if not is_inside_tree():
		await tree_entered
	size_tween = create_tween().set_parallel(true)
	var target_size = Vector2.ONE * (resource.base_size + (resource.base_size_add * (resource.stat_size-1)))
	size_tween.tween_property($CollisionShape2D,"scale",target_size, 2.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT_IN)
	size_tween.tween_property($HurtBox,"scale",target_size, 2.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT_IN)
	size_tween.tween_property($GoldPickupBox,"scale",target_size, 2.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT_IN)
	
	
	
func _update_mass():
	mass = resource.base_mass + (resource.base_mass_add * resource.stat_mass)
func update_weapons():
	if not weaponsManager:
		return
	var to_be_added = resource.weapons.duplicate()
	for ins in weaponsManager.get_children(true):
		if resource.weapons.has(ins.resource):
			to_be_added.erase(ins.resource)
		else:
			ins.queue_free.call_deferred()
	for res in to_be_added:
		var ins: Weapon = preload("res://Game/Weapons/CubeWeapon.tscn").instantiate()
		ins.resource = res
		ins.top_level = true
		ins.global_position = global_position + Vector2(randf_range(-20,20),randf_range(-20,20))
		weaponsManager.add_child(ins,true)

func update_resource():
	_update_size()
	_update_mass()
	
		
func _iframe_triggered():
	%AnimationPlayer.play("damage")
	await resource.iframe_elapsed
	%AnimationPlayer.stop()
	
func _ready():
	Player.instance = self
	resource_changed.connect(update_resource)
	iframe_triggered.connect(_iframe_triggered)
	health_depleted.connect(_health_depleted)
	resource.reset_health()
func _health_depleted():
	if not is_queued_for_deletion():
		queue_free()

	
	

var kick_str_max = 2000.0
var kick_str = 0.0
func trigger_kick():
	var kick_vec =  (get_global_mouse_position() - global_position).normalized()
	apply_central_impulse(kick_vec * kick_str * mass)
	
@export var move_towards_desired_velocity = true
@export var desired_velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if is_queued_for_deletion():
		return
	apply_central_force(desired_velocity * mass)
	resource.update_iframe(delta)
	if Input.is_action_just_pressed("player_kick"):
		kick_str = kick_str_max * 0.2
	elif Input.is_action_pressed("player_kick"):
		kick_str = clampf(kick_str + kick_str_max * delta * 6.0, 0.0, kick_str_max)
	elif Input.is_action_just_released("player_kick"):
		trigger_kick()
		kick_str = 0.0
	var kick_vec =  (get_global_mouse_position() - global_position).normalized()
	kick_vec = kick_vec * (kick_str / kick_str_max) * kick_str_max / 3
	$Line2D.points[0] = Vector2.ZERO
	$Line2D.points[1] = (kick_vec).rotated(-$Line2D.global_rotation) 
