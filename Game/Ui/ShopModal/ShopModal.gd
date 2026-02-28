@tool
extends Control
class_name ShopModal 

signal item_selected(item:ItemResource)
signal btn_pressed(btn:EquipItemButton)
@export var player: PlayerResource
@export var items:Array[ShopItemResource]:
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
		buttons[i].resource = null
	for i in range(buttons.size()):
		if i<items.size() and items[i]:
			buttons[i].resource = items[i]
			
			
func random_items():
	var available_items = ItemResource.get_available_items()
	print(available_items)
	var count =  get_buttons().size()
	var arr_indices = range(count)
	arr_indices.shuffle()
	var vs:Array[ShopItemResource] = []
	vs.resize(count)
	for i in arr_indices:
		if available_items.size()>0:
			var item: ItemResource = available_items.pop_at(randi_range(0, available_items.size()-1)).new()
			var shopItem = ShopItemResource.new()
			shopItem.item = item
			vs.set(i,shopItem)
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
	item_selected.connect(_item_selected)
	if get_tree().root == self:
		await modal()

func _item_selected(shopItem:ShopItemResource):
	prints(shopItem.price,player.money)
	if shopItem.quantity>0 and shopItem.price <= player.money:
		player.money -= shopItem.price
		shopItem.quantity -= 1
	
	
	
