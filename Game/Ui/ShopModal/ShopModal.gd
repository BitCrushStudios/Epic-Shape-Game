@tool
extends CanvasLayer
class_name ShopModal 

signal item_selected(item:ItemResource)
signal btn_pressed(btn:EquipItemButton)
@export var player:Player:
	set(v):
		if player and player.resource_changed.is_connected(update_player_ui):
			player.resource_changed.disconnect(update_player_ui)
		player = v
		if player:
			player.resource_changed.connect(update_player_ui)
		update_player_ui()
func update_player_ui():
	if not is_inside_tree():
		await tree_entered
	#%WaveLabel.text = "Next Wave - %d" % (player.current_wave + 1)
	#%CashLabel.text = "$ %d" % (player.money)
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
			
			
func setup_ui():
	var available_items = ItemResource.get_available_items()
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
var _random_items_action = setup_ui
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if Input.is_action_just_pressed("player_shop"):
		if not visible:
			await modal()
		else:
			pre_close_modal.emit()
signal pre_close_modal()
func modal():
	setup_ui()
	get_tree().paused=true
	visible = true
	await pre_close_modal
	visible = false
	get_tree().paused=false
	
func _ready():
	%AcceptButton.pressed.connect(pre_close_modal.emit)
	for btn in get_buttons():
		btn.item_selected.connect(item_selected.emit)
	item_selected.connect(_item_selected)
	if get_tree().current_scene == self:
		Player.instance = Player.new()
		Player.instance.resource = PlayerResource.new()
		await modal()

func _item_selected(shopItem:ShopItemResource):
	if shopItem.quantity>0 and shopItem.price <= player.resource.money:
		player.resource.money -= shopItem.price
		shopItem.quantity -= 1
		var arr = player.resource.inventory.duplicate()
		arr.append(shopItem.item)
		player.resource.inventory = arr
		#player.inventory = player.inventory
	
	
