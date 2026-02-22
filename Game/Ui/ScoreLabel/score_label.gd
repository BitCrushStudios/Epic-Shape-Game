@tool
extends Control
class_name ScoreLabel
@export var score = 50:
	get():
		return score
	set(v):
		score = v
		$Label.text = "+ %d Exp" % v
func _ready() -> void:
	score = score
	await $AnimationPlayer.animation_finished
	if not Engine.is_editor_hint():
		queue_free()
