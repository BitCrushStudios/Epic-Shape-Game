extends CanvasLayer


func _ready() -> void:
	%Menu.pressed.connect(_menu_pressed)
	%Restart.pressed.connect(_restart_pressed)
func _menu_pressed():
	get_tree().paused=false
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
func _restart_pressed():
	get_tree().paused=false
	get_tree().change_scene_to_file("res://Game/GameMain.tscn")
