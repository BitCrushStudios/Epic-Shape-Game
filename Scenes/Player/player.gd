extends RigidBody2D
class_name Player



@onready var spriteOrigin = $SpriteOrigin
@onready var sprite = $SpriteOrigin/Sprite
signal death
signal hit

var stance_tween: Tween


static var instance: Player

func _init():
	Player.instance = self
	
func _ready() -> void:
	PlayerHealth.instance.damage_received.connect(on_damage_recieved)


func on_damage_recieved(_damage, _source):
	
	$AnimationPlayer.play("Hit")
	$SlideAnimationPlayer.play("SlideHit")
	$Hurt.play()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Hit" or anim_name == "CubeHit":
		$AnimationPlayer.play("Hop")






func _on_area_2d_body_entered(body: Node2D) -> void:
		if body.is_in_group("cube"):
			print("cube")
			if $AnimationPlayer.is_animation_active():
				$AnimationPlayer.stop()
				$AnimationPlayer.play("CubeHit")
			else:
				$AnimationPlayer.play("CubeHit")


func _on_slide_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "SlideHit":
		$SlideAnimationPlayer.play("Slide")


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("cube"):
		print("cube")
		if $AnimationPlayer.is_animation_active():
			$AnimationPlayer.stop()
			$AnimationPlayer.play("CubeHit")
		else:
			$AnimationPlayer.play("CubeHit")


func _on_player_health_has_died() -> void:
	death.emit()
