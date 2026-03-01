extends Node

@onready var camera:Camera2D = get_parent()
var tween: Tween
@export var player:PlayerResource:
	set(v):
		if player and player.took_damage.is_connected(_recieved_damage):
			player.took_damage.disconnect(_recieved_damage)
		player = v
		if player:
			player.took_damage.connect(_recieved_damage)
func _ready():
	player = Player.instance.resource
func _recieved_damage(_damage:float):
	if tween:
		tween.kill()
	var dirr = Vector2.RIGHT.rotated(randf()*PI*2)*16.0
	tween = create_tween()
	tween.tween_property(camera,"offset", dirr, 0.1)
	tween.tween_property(camera,"offset", -dirr, 0.1)
	#tween.set_loops(10)
	tween.tween_property(camera,"offset",Vector2.ZERO,0.0)
	
