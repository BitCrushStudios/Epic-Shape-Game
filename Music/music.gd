extends Node

const tracks = [
	preload("res://Assets/Music/musinova-hyper-garden-jungle-breakbeat-drum-and-bass-loop-edit-356528.mp3"),
	preload("res://Assets/Music/musinova-technology-content-electronic-ambient-techno-loopable-edit-470305.mp3")
]
var track_index = 0

#func _ready() -> void:
	#$AudioStreamPlayer.stream = tracks[0]
	#$AudioStreamPlayer.finished.connect(_audio_finished)
	##$AudioStreamPlayer.play()
	#
func _audio_finished():
	track_index = (track_index + 1) % track_index.length()
