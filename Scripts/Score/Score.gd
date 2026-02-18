extends Node
const scorepath = "user://score.data"
var scores:Array[ScoreResource] = []

func _ready() -> void:
	var file = FileAccess.open(scorepath,FileAccess.READ)
	if FileAccess.get_open_error()!=OK:
		return
	scores = []
	for x in file.get_var():
		var s = ScoreResource.new()
		s.score = x
		scores.append(s)
	
func save():
	var file = FileAccess.open(scorepath,FileAccess.WRITE)
	if FileAccess.get_open_error()!=OK:
		return
	var xs = []
	for s in scores:
		xs.append(s.score)
	xs.sort()
	xs = xs.slice(0,10)
	file.store_var(xs)
