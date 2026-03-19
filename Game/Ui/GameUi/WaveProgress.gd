@tool
extends Control

@export var waves:Array[Wave] = []:
	set(v):
		waves = v
		update_ui()
@export var time = 80:
	set(v):
		time = v
		update_ui()
var _wave_indicators: Array[Control] = []
func update_ui():
	if not is_inside_tree():
		await tree_entered
	for c in _wave_indicators:
		c.queue_free.call_deferred()
	_wave_indicators = []
	var max_t = 0
	for w in waves:
		if w:
			max_t += w.condition.time
	var cur_t = 0
	for w in waves:
		var c = VBoxContainer.new()
		c.size.x = 32
		c.size.y = 64
		c.position.x -= c.size.x
		c.alignment = BoxContainer.ALIGNMENT_END
		add_child(c, true, Node.INTERNAL_MODE_FRONT)
		c.z_index = 4
		if w:
			c.position.x = cur_t/max_t*size.x
			for p in w.pairs:
				var t = TextureRect.new()
				t.texture = p.image
				t.size.y = 32
				t.size.x = 32
				t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				t.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
				c.add_child(t)
			cur_t += w.condition.time
				
		c.position.y = get_end().y - c.size.y
		_wave_indicators.append(c)
	if max_t:
		var ratio = time / max_t
		$ProgressRect.position.x = 0
		$ProgressRect.size.x = ratio * $ColorRect.size.x
		$PlayerRect.position.x = ratio * $ColorRect.size.x - $PlayerRect.size.x/2
	
	
