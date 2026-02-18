extends EntityComponent
class_name ChanceToDropHealOrb

@export var health: HealthComponent 
@export var chances = 1
func _enter_tree() -> void:
	health.has_died.connect(on_has_died)

func _exit_tree() -> void:
	health.has_died.disconnect(on_has_died)

func on_has_died():
	if not PlayerExperience.instance:
		return
	#var ups = 0
	#for u in PlayerExperience.instance.upgrades:
		#if u is HealthOrbChanceUpgradeResource:
			#ups+=1
	#for i in range(chances):
		#if randi_range(min(ups,20),20)==20:
			#var orb:RigidBody2D = preload("res://World/Scenes/Cube/health_orb.tscn").instantiate()
			#CubesManager.instance.add_child.call_deferred(orb)
			#orb.global_position = health.get_parent().global_position
