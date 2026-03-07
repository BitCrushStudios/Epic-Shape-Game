extends Control
signal input_event_received(key:InputEventKey)
var move_keymap:Dictionary[String, Array] = {
	"move_left": [null, null, null],
	"move_right": [null, null, null],
	"move_up": [null, null, null],
	"move_down": [null, null, null],
}
func game_key_set(btn:Button, input_name:String, index=0):
	btn.text = "[Press any key]"
	var e:InputEvent = await input_event_received
	btn.text = e.to_string()
	move_keymap[input_name][index] = e.keycode
	btn.accept_event()
	var s = ProjectSettings.get_setting("input/" + input_name)
	s['events'][index] = e
	
	ProjectSettings.save_custom("res://override.cfg")
	
	
func _input(event: InputEvent) -> void:
	input_event_received.emit(event)
	
			
# Called when the node enters the scene tree for the first time.
func set_up_key_button(btn:Button,input_name:String,index=0):
	btn.text = ""
	btn.pressed.connect(game_key_set.bind(btn, input_name, index))
	var s:Array = ProjectSettings.get_setting("input/" + input_name)['events']
	var e:InputEvent = s[index]
	move_keymap[input_name][index] = e
	btn.text = e.as_text()
	
func _ready() -> void:
	audio_toggle_prop(%SoundToggle, "game/audio/sound/enabled")
	audio_volume_prop(%SoundVolume, "game/audio/sound/volume")
	audio_toggle_prop(%MusicToggle, "game/audio/sound/enabled")
	audio_volume_prop(%MusicVolume, "game/audio/music/volume")
	
	set_up_key_button(%LeftKeyButton1, "move_left", 0)
	set_up_key_button(%LeftKeyButton2, "move_left", 1)
	set_up_key_button(%LeftKeyButton3, "move_left", 2)
	
	set_up_key_button(%RightKeyButton1, "move_right", 0)
	set_up_key_button(%RightKeyButton2, "move_right", 1)
	set_up_key_button(%RightKeyButton3, "move_right", 2)
	
	set_up_key_button(%UpKeyButton1, "move_up", 0)
	set_up_key_button(%UpKeyButton2, "move_up", 1)
	set_up_key_button(%UpKeyButton3, "move_up", 2)
	
	set_up_key_button(%DownKeyButton1, "move_down", 0)
	set_up_key_button(%DownKeyButton2, "move_down", 1)
	set_up_key_button(%DownKeyButton3, "move_down", 2)
	
	%FullScreenToggle.button_pressed = ProjectSettings.get_setting("display/window/size/mode") == DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN 
	%FullScreenToggle.toggled.connect(fullscreen_toggle)
	
func audio_volume_prop(node:Slider, key:String):
	node.value = ProjectSettings.get_setting(key)
	print(node.value)
	node.value_changed.connect(func(v:float):
		ProjectSettings.set_setting(key, v)
		ProjectSettings.save_custom("res://override.cfg")
	)
	
func audio_toggle_prop(node:CheckBox, key:String):
	node.button_pressed = ProjectSettings.get_setting(key)
	node.toggled.connect(func(v:bool):
		ProjectSettings.set_setting(key, v)
		ProjectSettings.save_custom("res://override.cfg")
	)
	
func fullscreen_toggle(v:bool):
	var winMode: DisplayServer.WindowMode = ProjectSettings.get_setting("display/window/size/mode")
	winMode = (
		DisplayServer.WindowMode.WINDOW_MODE_WINDOWED 
		if winMode==DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN 
		else DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN
	)
	DisplayServer.window_set_mode(winMode)
	ProjectSettings.set_setting("display/window/size/mode",winMode)
	ProjectSettings.save_custom("res://override.cfg")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	#var tween = create_tween()
	#(tween.tween_property(
		#$Camera2D, 
		#'global_position', 
		#$Control.global_position, 
		#1.0
	#).set_ease(Tween.EASE_IN_OUT)
	#.set_trans(Tween.TRANS_CUBIC))
	#await tween.finished
	
	get_tree().change_scene_to_file("res://Game/GameMain.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	var tween = create_tween()
	tween.tween_property($Camera2D, 'global_position', $SettingContainer.global_position, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	


func _on_settings_back_pressed() -> void:
	var tween = create_tween()
	tween.tween_property($Camera2D, 'global_position', $MainContainer.global_position, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	


func _on_wishlist_pressed() -> void:
	OS.shell_open("")
