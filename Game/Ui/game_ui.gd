extends CanvasLayer
class_name GameUi


@export var player: PlayerResource:
	set(v):
		if player and player.changed.is_connected(_player_changed):
			player.changed.disconnect(_player_changed)
		if player and player.level_changed.is_connected(_player_level_changed):
			player.level_changed.disconnect(_player_level_changed)
		if player and player.took_damage.is_connected(_recieved_damage):
			player.took_damage.disconnect(_recieved_damage)
		if player and player.health_changed.is_connected(_health_changed):
			player.took_damage.disconnect(_health_changed)
		player = v
		if player:
			player.changed.connect(_player_changed)
			player.level_changed.connect(_player_level_changed)
			player.took_damage.connect(_recieved_damage)
			player.took_damage.connect(_health_changed)

func _ready():
	%HurtOverlay.modulate = Color.TRANSPARENT
	%HurtOverlay.show()
	_player_level_changed()
	if not get_tree().current_scene == self:
		player = Player.instance.resource
	
func _player_changed():
	%ExpBar.min_value = player.current_level_exp_required
	%ExpBar.max_value = player.next_level_exp_required
	%ExpBar.value = player.experience

func _player_level_changed():
	for c in %LevelsGained.get_children(true):
		c.queue_free()
	
	for i in range(player.levels_gained):
		var star = preload("res://Game/Ui/GameUi/UpgradeStar.tscn").instantiate()
		%LevelsGained.add_child(star,true,Node.INTERNAL_MODE_FRONT)

func _process(_delta:float):
	if not Player.instance:
		return
	if EnemyManager.instance.active_wave:
		var active_wave = EnemyManager.instance.active_wave
		%TimerLabel.text = "%0.2f" % (active_wave.time_max - active_wave.time_current)
	
	
var hurt_tween:Tween
func _health_changed():
	%HealthBar.max_value = player.health_max
	%HealthBar.value = player.health_current
	%HealthLabel.text = "%d / %d" % [
		Player.instance.health_current, 
		Player.instance.health_max
	]
	
func _recieved_damage(_damage:float):
	if hurt_tween:
		hurt_tween.kill()
	hurt_tween = create_tween()
	hurt_tween.tween_property(%HurtOverlay,"modulate",Color(1,1,1,1),0.5)
	hurt_tween.tween_property(%HurtOverlay,"modulate",Color(1,1,1,0),0.5)
