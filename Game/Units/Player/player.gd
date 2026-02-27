@tool
extends Unit
class_name Player

static var instance:Player
@export var resource: PlayerResource

func _init():
	health_max = 30.0
var iframe_max:
	get():
		return resource.stat_iframe * 0.5
var iframe = 0.0
signal iframe_elapse()
var size_tween:Tween
func update_size():
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
func update_mass():
	mass = resource.base_mass + (resource.base_mass_add * resource.stat_mass)
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
	var upgrade:UpgradeResource = await modal.modal()
	upgrade.apply()
	get_tree().paused=false
	
func show_shop_modal():
	get_tree().paused=true
	var modal: ShopModal = preload("res://Game/Ui/ShopModal/ShopModal.tscn").instantiate()
	$CanvasLayer.add_child(modal)
	await modal.modal()
	get_tree().paused=false

func show_equip_modal():
	get_tree().paused=true
	var modal: EquipModal = preload("res://Game/Ui/EquipModal/EquipModal.tscn").instantiate()
	$CanvasLayer.add_child(modal)
	await modal.tree_entered
	await modal.modal()
	get_tree().paused=false

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
		
	if Input.is_action_just_pressed("dev_player_upgrade"):
		show_upgrade_modal()
		
	if Input.is_action_just_pressed("dev_player_shop"):
		show_shop_modal()
		
	if Input.is_action_just_pressed("dev_player_equip"):
		show_equip_modal()
		
	if Input.is_action_just_pressed("dev_player_extra_weapon"):
		var upgrade = ExtraWeaponUpgradeResource.new().apply()
	
	if Input.is_action_just_pressed("dev_player_size_up"):
		resource.stat_size += 1
		
	if Input.is_action_just_pressed("dev_player_size_down"):
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
