extends Resource
class_name WeaponSpawn

@export var offset:Vector2 = Vector2.ZERO:
	set(v):
		offset = v
		emit_changed()
		
@export var resource:WeaponResource = WeaponResource.new():
	set(v):
		resource = v
		emit_changed()
		
