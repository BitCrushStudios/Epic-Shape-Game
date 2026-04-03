class_name DamageNumbers extends Label

var damage_value:int
var color:Color = Color(1,1,1,0)
var wade_out_time:float = 1.0

func _ready() -> void:
	text = str(damage_value)
	var tweener = create_tween()
	tweener.set_parallel(true)
	tweener.tween_property(self,"position",position+Vector2(randi_range(-100,100),randi_range(-100,100)),wade_out_time)

	modulate = color
	tweener.play()
	await tweener.finished
	queue_free()
