@tool
extends Unit
class_name Player

static var instance:Player
@export var resource: PlayerResource:
	set(v):
		if resource and resource.changed.is_connected(update_resource):
				resource.changed.disconnect(update_resource)
		resource = v
		if resource:
			resource.changed.connect(update_resource)
		update_resource()
		

func _init():
	health_max = 30.0

var iframe_max:
	get():
		return resource.stat_iframe * 0.5
var iframe = 0.0
signal iframe_elapse()

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
	var weapons = resource.weapons
	for c in Weapon.instances:
		if weapons.has(c.resource):
			weapons.erase(c.resource)
		else:
			c.queue_free.call_deferred()
	for res in weapons:
		var c = WeaponsManager.instance.add_weapon(res)
		
	
func update_resource():
	_update_size()
	_update_mass()
	update_weapons()
	
func apply_damage(damage:float):
	if iframe<=0:
		super(damage)
		
func _recieved_damage(_damage:float):
	%AnimationPlayer.play("damage")
	iframe = iframe_max
	await iframe_elapse
	%AnimationPlayer.stop()
	
func _ready():
	Player.instance = self
	recieved_damage.connect(_recieved_damage)
	
var mouse_origin

func show_upgrade_modal():
	get_tree().paused=true
	var modal: UpgradeModal = preload("res://Game/Ui/UpgradeModal/UpgradeModal.tscn").instantiate()
	$CanvasLayer.add_child(modal)
	modal.player = resource
	await modal.modal()
	modal.queue_free()
	get_tree().paused=false
	
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
	
	if iframe>0:
		iframe = iframe - delta
		if iframe<=0:
			iframe_elapse.emit()
			
	var mvec = Input.get_vector("move_left","move_right","move_up","move_down")
	var desired_velocity = mvec * resource.speed
	desired_velocity = desired_velocity - linear_velocity
	desired_velocity = desired_velocity.limit_length(resource.speed) / resource.speed
	desired_velocity = desired_velocity * resource.speed * resource.accel_mult
	apply_central_force(desired_velocity * mass)
	
	super(delta)
