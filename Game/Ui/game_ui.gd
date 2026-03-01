extends CanvasLayer
class_name GameUi


@export var player: PlayerResource:
	set(v):
		if player and player.changed.is_connected(update_exp_ui):
			player.changed.disconnect(update_exp_ui)
		if player and player.level_changed.is_connected(update_level_ui):
			player.level_changed.disconnect(update_level_ui)
		if player and player.took_damage.is_connected(trigger_damage_ui):
			player.took_damage.disconnect(trigger_damage_ui)
		if player and player.health_changed.is_connected(update_health_ui):
			player.health_changed.disconnect(update_health_ui)
		player = v
		if player:
			player.changed.connect(update_exp_ui)
			player.level_changed.connect(update_level_ui)
			player.took_damage.connect(trigger_damage_ui)
			player.health_changed.connect(update_health_ui)

func _ready():
	%HurtOverlay.modulate = Color.TRANSPARENT
	%HurtOverlay.show()
	update_all_ui()
	if not get_tree().current_scene == self:
		player = Player.instance.resource
	
func update_exp_ui():
	%ExpBar.min_value = player.current_level_exp_required
	%ExpBar.max_value = player.next_level_exp_required
	%ExpBar.value = player.experience
	%ExpLabel.text = "%d / %d" % [
		player.experience - player.current_level_exp_required, 
		player.next_level_exp_required - player.current_level_exp_required 
	]

func update_level_ui():
	for c in %LevelsGained.get_children(true):
		c.queue_free()
	
	for i in range(player.levels_gained):
		var star = preload("res://Game/Ui/GameUi/UpgradeStar.tscn").instantiate()
		%LevelsGained.add_child(star,true,Node.INTERNAL_MODE_FRONT)
		
func update_all_ui():
	update_level_ui()
	update_exp_ui()
	update_health_ui()

func _process(_delta:float):
	if not Player.instance:
		return
	if EnemyManager.instance.active_wave:
		var active_wave = EnemyManager.instance.active_wave
		%TimerLabel.text = "%0.2f" % (active_wave.time_max - active_wave.time_current)
	
	
var hurt_tween:Tween
func update_health_ui():
	%HealthBar.max_value = player.health_max
	%HealthBar.value = player.health_current
	%HealthLabel.text = "%d / %d" % [
		player.health_current, 
		player.health_max
	]
	
func trigger_damage_ui(_damage:float):
	if hurt_tween:
		hurt_tween.kill()
	hurt_tween = create_tween()
	hurt_tween.tween_property(%HurtOverlay,"modulate",Color(1,1,1,1),0.5)
	hurt_tween.tween_property(%HurtOverlay,"modulate",Color(1,1,1,0),0.5)
