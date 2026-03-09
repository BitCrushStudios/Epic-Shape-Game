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
	size_tween = create_tween()
	size_tween.tween_property(
		$CollisionShape2D, 
		"scale", 
		Vector2.ONE * (resource.base_size + (resource.base_size_add * (resource.stat_size-1))), 
		2.0
	).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT_IN)
	
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

func show_upgrade_modal():
	if resource.levels_gained>0:
		get_tree().paused=true
		var modal: UpgradeModal = preload("res://Game/Ui/UpgradeModal/UpgradeModal.tscn").instantiate()
		$CanvasLayer.add_child(modal)
		modal.player = resource
		await modal.modal(resource.levels_gained)
		modal.queue_free()
		get_tree().paused=false
		resource.levels_gained = 0
	
	

func show_equip_modal():
	get_tree().paused=true
	var modal: EquipModal = preload("res://Game/Ui/EquipModal/EquipModal.tscn").instantiate()
	$CanvasLayer.add_child(modal)
	modal.player = resource
	await modal.modal()
	modal.queue_free()
	get_tree().paused=false
	
@export var move_towards_desired_velocity = true
@export var desired_velocity = Vector2.ZERO
func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if is_queued_for_deletion():
		return
	apply_central_force(desired_velocity * mass)
	resource.update_iframe(delta)
	
	
