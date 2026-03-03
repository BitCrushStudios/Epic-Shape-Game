@tool
extends CanvasLayer
class_name GameUi

@export var health_max = 1.0:
	set(v):
		health_max = v
		update_all_ui()
@export var health_current = 1.0:
	set(v):
		health_current = v
		update_all_ui()
@export var exp_max = 1.0:
	set(v):
		exp_max = v
		update_all_ui()
@export var exp_current = 1.0:
	set(v):
		exp_current = v
		update_all_ui()
@export var upgrade_star_count = 0:
	set(v):
		upgrade_star_count = v
		update_all_ui()
@export var current_wave = 1:
	set(v):
		current_wave = v
		update_all_ui()
@export var time_remaining = 30.0:
	set(v):
		time_remaining = v
		update_all_ui()
@export var wave_composition: Array[WavePair]:
	set(v):
		wave_composition = v
		update_all_ui()
@export var show_hurt_indicator = false:
	set(v):
		show_hurt_indicator = v
		update_all_ui()

func _ready():
	%HurtOverlay.modulate = Color.TRANSPARENT
	%HurtOverlay.show()
	update_all_ui()
	
var hurt_tween:Tween
func _update_hurt_indicator():
	if hurt_tween:
		hurt_tween.kill()
	hurt_tween = create_tween()
	if show_hurt_indicator:
		hurt_tween.tween_property(%HurtOverlay,"modulate",Color(1,1,1,1),0.5)
	else:
		hurt_tween.tween_property(%HurtOverlay,"modulate",Color(1,1,1,0),0.5)
	
func _update_exp_ui():
	%ExpBar.min_value = 0
	%ExpBar.max_value = exp_max
	%ExpBar.value = exp_current
	%ExpLabel.text = "%d / %d" % [
		exp_current, 
		exp_max 
	]
func _update_level_ui():
	var diff = upgrade_star_count - %LevelsGained.get_child_count(true)
	print(diff)
	if diff<0:
		for c in %LevelsGained.get_children(true).slice(0, -diff):
			c.queue_free()
	elif diff>0:
		for i in range(diff):
			%LevelsGained.add_child(
				preload("res://Game/Ui/GameUi/UpgradeStar.tscn").instantiate(),
				true,
				Node.INTERNAL_MODE_FRONT
			)
		
func _update_health_ui():
	%HealthBar.max_value = health_max
	%HealthBar.value = health_current
	%HealthLabel.text = "%d / %d" % [health_current, health_max]

func _update_enemy_wave_ui():
	for c in %WaveOverview.get_children(true):
		c.queue_free.call_deferred()
	for pair in wave_composition:
		var pair_ui:WavePairUi = preload("res://Game/Waves/WavePairUi.tscn").instantiate()
		pair_ui.resource = pair
	
func update_all_ui():
	if not is_inside_tree():
		await tree_entered
	_update_level_ui()
	_update_exp_ui()
	_update_health_ui()
	_update_enemy_wave_ui()
	_update_hurt_indicator()

func _process(_delta:float):
	%WaveLabel.text = "Wave %d" % current_wave
	%TimerLabel.text = "%0.2f" % (time_remaining)
	
	
