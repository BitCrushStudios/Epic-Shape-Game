extends EntityComponent
class_name DamagePlayerOnCollide
@export var self_death_on_collide=true
@export var damage = 1.0
@export var health:HealthComponent
#
#func _enter_tree() -> void:
	#get_parent().body_entered.connect(_on_body_entered)
#
#func _exit_tree() -> void:
	#get_parent().body_entered.disconnect(_on_body_entered)

func _process(_delta: float) -> void:
	for other in (get_parent() as RigidBody2D).get_colliding_bodies():
		if  self_death_on_collide and not get_parent().is_queued_for_deletion():
			health.trigger_death()
		if other is Player:
			var player_health = other.get_node_or_null("PlayerHealth")
			if player_health is PlayerHealth:
				player_health.apply_damage(damage, self )
		
