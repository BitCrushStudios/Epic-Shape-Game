extends Node

@onready var camera:Camera2D = get_parent()
var tween: Tween
func _ready():
	Player.instance.recieved_damage.connect(_recieved_damage)

func _recieved_damage(_damage:float):
	if tween:
		tween.kill()
	var dirr = Vector2.RIGHT.rotated(randf()*PI*2)*16.0
	tween = create_tween()
	tween.tween_property(camera,"offset", dirr, 0.1)
	tween.tween_property(camera,"offset", -dirr, 0.1)
	#tween.set_loops(10)
	tween.tween_property(camera,"offset",Vector2.ZERO,0.0)
	
