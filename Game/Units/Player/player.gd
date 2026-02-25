@tool
extends Unit
class_name Player
@export_category("Stats")
@export var stat_size = 1:
	get():
		return stat_size
	set(v):
		stat_size = clampi(v, 0, stat_size_max)
@export var stat_size_max = 10

@export var stat_speed = 1:
	get():
		return stat_speed
	set(v):
		stat_speed = clampi(v, 0, stat_speed_max)
@export var stat_speed_max = 10

@export var stat_iframe = 1:
	get():
		return stat_iframe
	set(v):
		stat_iframe = clampi(v, 0, stat_iframe_max)
@export var stat_iframe_max = 10

@export var stat_mass = 1:
	get():
		return stat_mass
	set(v):
		stat_mass = clampi(v, 0, stat_mass_max)
		update_mass()
@export var stat_mass_max = 10

@export_category("Stats Base")
@export var base_mass = 10.0:
	set(v):
		base_mass = v
		update_mass()
@export var base_mass_add = 1.0:
	set(v):
		base_mass_add = v
		update_mass()
@export var base_speed = 500.0
@export var base_speed_add = 100.0
@export var accel_mult = 10.0
@export var exp_rate = 1.1

@export_category("Stat Result")
@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_NONE) 
var speed: float:
	get():
		return base_speed + (base_speed_add * stat_speed)
@export var experience = 0.0
var exp_level: float:
	get():
		return experience/exp(exp_rate)

func _init():
	health_max = 30.0
static var instance:Player
var iframe_max:
	get():
		return stat_iframe * 0.5
var iframe = 0.0
signal iframe_elapse()
func update_mass():
	mass = base_mass + (base_mass_add * stat_mass)
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
	var modal: UpgradeModal = preload("res://Game/Ui/UpgradeModal.tscn").instantiate()
	$CanvasLayer.add_child(modal)
	var upgrade:UpgradeResource = await modal.modal()
	upgrade.apply()
	get_tree().paused=false
	
func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if Input.is_action_just_pressed("dev_player_upgrade"):
		show_upgrade_modal()
	if Input.is_action_just_pressed("dev_player_extra_weapon"):
		var upgrade = ExtraWeaponUpgradeResource.new().apply()
	if iframe>0:
		iframe = iframe - delta
		if iframe<=0:
			iframe_elapse.emit()
	var mvec = Input.get_vector("move_left","move_right","move_up","move_down")
	var desired_velocity = mvec * speed
	desired_velocity = desired_velocity - linear_velocity
	desired_velocity = desired_velocity.limit_length(speed) / speed
	desired_velocity = desired_velocity * speed * accel_mult
	
	print(speed,desired_velocity,desired_velocity*mass)
	apply_central_force(desired_velocity * mass)
	super(delta)
