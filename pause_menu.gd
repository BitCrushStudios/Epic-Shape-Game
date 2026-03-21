extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_mouse_mode():
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 
	elif OS.has_feature("standalone"):
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not get_tree().paused and Input.is_action_just_pressed("dev_game_pause"):
		visible = not visible
		get_tree().paused = visible
		update_mouse_mode()



func _on_resume_pressed() -> void:
	visible = false
	get_tree().paused = false
	update_mouse_mode()




func _on_return_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
