extends EntityComponent
class_name PlayerMovementComponent

@export var walk_speed = 2000.0
@export var slide_speed = 5000.0

@export var walk_sprite:Sprite2D
@export var slide_sprite:Sprite2D

var desired_velocity = Vector2.ZERO
var direction = Vector2.LEFT
@export var auto_slide = false

var direction_tween: Tween
var use_mouse = false


func _physics_process(_delta: float) -> void:
	Player.instance.apply_central_force(_process_movement())
	
func flip(leftward: bool):
	if direction_tween:
		direction_tween.stop()
	Player.instance.spriteOrigin.scale.x = roundf(Player.instance.spriteOrigin.scale.x)
	direction_tween = create_tween()
	direction_tween.tween_property(Player.instance.spriteOrigin, "scale", Vector2(1 if leftward else -1, 1), 0.1)

func _process_movement():
	var mvec = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var use_slide = Input.is_action_pressed("slide") or auto_slide
	
	if mvec:
		use_mouse = false
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		use_mouse = true
		
	if use_mouse: 
		var mpos = get_viewport().get_camera_2d().get_global_mouse_position()
		mvec = (mpos - Player.instance.global_position)
		mvec = mvec.normalized() * (clamp(mvec.length(),25,300)-25)/275
		
	var applied_speed = walk_speed
	if use_slide:
		applied_speed = slide_speed
	slide_sprite.visible=use_slide and Player.instance.linear_velocity.length()>100
	walk_sprite.visible=not slide_sprite.visible
	
	if (mvec.x > 0 and not direction.x > 0) or (mvec.x < 0 and not direction.x < 0):
		flip(mvec.x < 0)
	if mvec:
		direction = mvec
	desired_velocity = mvec * applied_speed
	# Respond within 0.05 of a second
	
	var velocity_diff = ((desired_velocity - Player.instance.linear_velocity)).limit_length(applied_speed) * Player.instance.mass * 10.0
	if use_slide:
		velocity_diff = (desired_velocity ).limit_length(applied_speed)* Player.instance.mass 
	return velocity_diff
