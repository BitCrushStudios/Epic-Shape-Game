extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	var tween = create_tween()
	(tween.tween_property(
		$Camera2D, 
		'global_position', 
		$Control.global_position, 
		1.0
	).set_ease(Tween.EASE_IN_OUT)
	.set_trans(Tween.TRANS_CUBIC))
	await tween.finished
	
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	var tween = create_tween()
	tween.tween_property($Camera2D, 'global_position', $SettingContainer.global_position, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	


func _on_settings_back_pressed() -> void:
	var tween = create_tween()
	tween.tween_property($Camera2D, 'global_position', $MainContainer.global_position, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
