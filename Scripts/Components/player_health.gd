extends HealthComponent
class_name PlayerHealth


var invulnerable = false
@export var invulnerable_time = 1.0
static var instance: PlayerHealth

func _init():
	super._init()
	instance = self
	
func apply_damage(damage: float, source: Node):
	if invulnerable:
		print("i frame")
		return
	invulnerable = true
	
	super.apply_damage(damage,source)
	$"..".hit.emit()
	await get_tree().create_timer(0.5).timeout
	invulnerable = false

func trigger_death():
	var score = ScoreResource.new()
	score.score = PlayerExperience.instance.score
	Score.scores.append(score)
	Score.save()
	#super.trigger_death()
