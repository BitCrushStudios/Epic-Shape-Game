extends CanvasLayer
signal menu_ended()
signal switch()

func _ready() -> void:
	%Menu.pressed.connect(_menu_pressed)
	%Restart.pressed.connect(_restart_pressed)

func _menu_pressed():
	menu_ended.emit()
	await switch
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
	
func _restart_pressed():
	menu_ended.emit()
	await switch
	get_tree().change_scene_to_file("res://Game/GameMain.tscn")

func modal():
	get_tree().paused=true
	$AnimationPlayer.play("Fly In")
	await menu_ended
	$AnimationPlayer.play("Fly Out")
	await $AnimationPlayer.animation_finished
	get_tree().paused=false
	switch.emit()
