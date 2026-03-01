extends CanvasLayer

func _ready():
	%HurtOverlay.modulate = Color.TRANSPARENT
	%HurtOverlay.show()
	await get_tree().process_frame
	Player.instance.recieved_damage.connect(_recieved_damage)
	
func _process(_delta:float):
	if not Player.instance:
		return
	%HealthBar.max_value = Player.instance.health_max
	%HealthBar.value = Player.instance.health_current
	%HealthLabel.text = "%d / %d" % [Player.instance.health_current, Player.instance.health_max]
	
	%ExpBar.max_value = Player.instance.resource.experience
	%ExpBar.value = Player.instance.resource.experience
	
	%
	
var hurt_tween:Tween

func _recieved_damage(_damage:float):
	if hurt_tween:
		hurt_tween.kill()
	hurt_tween = create_tween()
	hurt_tween.tween_property(%HurtOverlay,"modulate",Color(1,1,1,1),0.5)
	hurt_tween.tween_property(%HurtOverlay,"modulate",Color(1,1,1,0),0.5)
