extends Resource
class_name WeaponResource


@export var activation_max = 1.0
@export var normal_texture: Texture2D:
	set(v):
		normal_texture = v
		emit_changed()
@export var activated_texture: Texture2D:
	set(v):
		activated_texture = v
		emit_changed()
@export var name:String="Weapon":
	set(v):
		name = v
		emit_changed()
@export var items: Array[ItemResource] = []:
	set(v):
		items = v
		emit_changed()
@export var damage = 1.0:
	set(v):
		damage = v
		emit_changed()
