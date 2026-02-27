@tool
extends Control
class_name ShopModal 

signal item_selected(item:ItemResource)
@export var player: PlayerResource
@export var items:Array[ItemResource]:
	set(v):
		items = v
		items_changed()
	
func get_buttons() -> Array[ShopButton]:
	return [
		%ShopButton1,
		%ShopButton2,
		%ShopButton3,
		%ShopButton4,
		%ShopButton5,
	]

func items_changed():
	if not is_inside_tree():
		await tree_entered
	var buttons = get_buttons()
	for i in range(buttons.size()):
		buttons[i].hide()
		buttons[i].resource = null
	for i in range(buttons.size()):
		if i<items.size() and items[i]:
			buttons[i].show()
			buttons[i].resource = items[i]
			
			
func random_items():
	var available_items = ItemResource.get_available_items()
	print(available_items)
	var count =  get_buttons().size()
	var arr_indices = range(count)
	arr_indices.shuffle()
	var vs:Array[ItemResource] = []
	vs.resize(count)
	for i in arr_indices:
		if available_items.size()>0:
			var item: ItemResource = available_items.pop_at(randi_range(0, available_items.size()-1)).new()
			prints(i, item)
			vs.set(i,item)
		else:
			vs.set(i,null)
	items = vs
	
@export_tool_button("Randomize")
var _random_items_action = random_items
		
func modal():
	#items_changed()
	$AnimationPlayer.play("open")
	await %AcceptButton.pressed
	$AnimationPlayer.play("close")
	await $AnimationPlayer.animation_finished

func _ready():
	for btn in get_buttons():
		btn.item_selected.connect(item_selected.emit)
	if get_tree().root == self:
		await modal()
