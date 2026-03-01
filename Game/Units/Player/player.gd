@tool
extends RigidBody2D
class_name Player

static var instance:Player
@export var resource: PlayerResource:
	set(v):
		if resource and resource.changed.is_connected(update_resource):
				resource.changed.disconnect(update_resource)
		if resource and resource.weapons_changed.is_connected(update_weapons):
				resource.weapons_changed.disconnect(update_weapons)
		resource = v
		if resource:
			resource.changed.connect(update_resource)
			resource.weapons_changed.connect(update_weapons)
		update_resource()
		update_weapons()

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
	var to_be_added = resource.weapons.duplicate()
	for ins in Weapon.instances:
		if resource.weapons.has(ins.resource):
			to_be_added.erase(ins.resource)
		else:
			ins.queue_free.call_deferred()
	prints("WEP", resource.weapons.size(), to_be_added.size())
	for res in to_be_added:
		var ins: Weapon = preload("res://Game/Weapons/CubeWeapon.tscn").instantiate()
		ins.resource = res
		ins.top_level = true
		ins.global_position = global_position + Vector2(randf_range(-20,20),randf_range(-20,20))
		add_child(ins,true)
			
func update_resource():
	_update_size()
	_update_mass()
	
		
func _iframe_triggered():
	%AnimationPlayer.play("damage")
	await resource.iframe_elapsed
	%AnimationPlayer.stop()
	
func _ready():
	Player.instance = self
	resource.iframe_triggered.connect(_iframe_triggered)
	resource.reset_health()
	for w in Weapon.instances:
		resource.weapons.append(w.resource)
	
var mouse_origin

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
	
func show_shop_modal():
	get_tree().paused=true
	var modal: ShopModal = preload("res://Game/Ui/ShopModal/ShopModal.tscn").instantiate()
	$CanvasLayer.add_child(modal)
	modal.player = resource
	await modal.modal()
	modal.queue_free()
	get_tree().paused=false

func show_equip_modal():
	get_tree().paused=true
	var modal: EquipModal = preload("res://Game/Ui/EquipModal/EquipModal.tscn").instantiate()
	$CanvasLayer.add_child(modal)
	modal.player = resource
	await modal.modal()
	modal.queue_free()
	get_tree().paused=false

func _physics_process(delta: float) -> void:
	apply_torque(-rotation_degrees * 1000.0 * mass)
	if Engine.is_editor_hint():
		return
	elif Input.is_action_just_pressed("dev_player_upgrade"):
		show_upgrade_modal()
	elif Input.is_action_just_pressed("dev_player_shop"):
		show_shop_modal()
	elif Input.is_action_just_pressed("dev_player_equip"):
		show_equip_modal()
	elif Input.is_action_just_pressed("dev_player_extra_weapon"):
		var upgrade = ExtraWeaponUpgradeResource.new().apply(resource)
	elif Input.is_action_just_pressed("dev_player_size_up"):
		resource.stat_size += 1
	elif Input.is_action_just_pressed("dev_player_size_down"):
		resource.stat_size -= 1
	resource.update_iframe(delta)
			
	var mvec = Input.get_vector("move_left","move_right","move_up","move_down")
	var desired_velocity = mvec * resource.speed
	desired_velocity = desired_velocity - linear_velocity
	desired_velocity = desired_velocity.limit_length(resource.speed) / resource.speed
	desired_velocity = desired_velocity * resource.speed * resource.accel_mult
	apply_central_force(desired_velocity * mass)
	
