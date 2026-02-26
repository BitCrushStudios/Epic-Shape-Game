@tool
extends Resource
class_name CustomArray

var _from
var _to

func _init(from, to):
	assert(from <= to)
	_from = from
	_to = to

func _iter_init(iter):
	iter[0] = _from
	return iter[0] < _to

func _iter_next(iter):
	iter[0] += 1
	return iter[0] < _to

func _iter_get(iter):
	return iter
