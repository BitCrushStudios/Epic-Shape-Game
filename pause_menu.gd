extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (not get_tree().paused or visible) and Input.is_action_just_pressed("dev_game_pause"):
		if visible:			
			await close()
		else:
			await modal()



func _on_resume_pressed() -> void:
	await close()




func _on_return_pressed() -> void:
	await close()
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")

signal modal_closing()
signal modal_closed()
func close():
	modal_closing.emit()
	await modal_closed
func modal():
	$AnimationPlayer.play("Fly In")
	get_tree().paused = true
	if OS.has_feature("standalone"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 
	await modal_closing
	$AnimationPlayer.play("Fly Out")
	get_tree().paused = false
	visible = false
	if OS.has_feature("standalone"):
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	modal_closed.emit()
	
	
	
