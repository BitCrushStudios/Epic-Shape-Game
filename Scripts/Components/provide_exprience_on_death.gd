extends EntityComponent
class_name ProvidesExperienceOnDeath

@export var experience:float = 10.0
@export var health: HealthComponent 

func _enter_tree() -> void:
	health.has_died.connect(on_has_died)

func _exit_tree() -> void:
	health.has_died.disconnect(on_has_died)

func on_has_died():
	if not PlayerExperience.instance:
		return
	PlayerExperience.instance.apply_exp_gain(experience, self)
