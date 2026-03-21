@tool
extends CanvasLayer
class_name ShopModal 

signal item_selected(item:ItemResource)
signal btn_pressed(btn:EquipItemButton)
@export var animation_player : AnimationPlayer


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
	if player:
		money = player.resource.money
	#%WaveLabel.text = "Next Wave - %d" % (player.current_wave + 1)
	#%CashLabel.text = "$ %d" % (player.money)
@export var money:int = 1000:
	set(v):
		money = v
		_changed()
@export var items:Array[ShopItemResource]:
	set(v):
		items = v
		_changed()

func get_buttons() -> Array[ShopButton]:
	return [
		%ShopButton1,
		%ShopButton2,
		%ShopButton3,
		%ShopButton4,
		%ShopButton5,
	]

func _changed():
	if not is_inside_tree():
		await tree_entered
	var buttons = get_buttons()
	for i in range(buttons.size()):
		buttons[i].resource = null
	for i in range(buttons.size()):
		if i<items.size() and items[i]:
			buttons[i].resource = items[i]
			buttons[i].disabled = items[i].price>money 
			if not buttons[i].disabled and get_parent():
				var gameMain:GameMain = get_parent()
				buttons[i].disabled = items[i].item.poll(gameMain)<=0
	
	%RerollButton.disabled = money<10
	%MoneyLabel.text = "$ %d" % money
	
func swapEmpty():
	var available_items = ItemResource.get_available_items()
	var p = get_parent()
	if p:
		available_items = available_items.filter(func(x):
			return x.poll(p)>0
		)
	var count =  get_buttons().size()
	var arr_indices = range(count)
	arr_indices.shuffle()
	var vs:Array[ShopItemResource] = items
	vs.resize(count)
	for i in arr_indices:
		if not vs[i] or vs[i].quantity==0:
			vs[i] = null
		if vs[i]==null and available_items.size()>0:
			var Item: GDScript = available_items.pop_at(randi_range(0, available_items.size()-1))
			var item: ItemResource = Item.new()
			print(item, Item.poll(get_parent()))
			var shopItem = ShopItemResource.new()
			shopItem.item = item
			vs.set(i,shopItem)
	items = vs
func setup_ui():
	items = []
	swapEmpty()

@export_tool_button("Randomize")
var _random_items_action = setup_ui
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if (not get_tree().paused or visible) and Input.is_action_just_pressed("player_shop"):
		if not visible:
			await modal()
		else:
			modal_closing.emit()
signal modal_closing()
signal modal_closed()
func close():
	modal_closing.emit()
	await modal_closed
func modal():
	if OS.has_feature("standalone"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$AnimationPlayer.play("Fly In")
	get_tree().paused=true
	visible = true
	await modal_closing
	visible = false
	$AnimationPlayer.play("Fly Out")
	get_tree().paused=false
	if OS.has_feature("standalone"):
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	modal_closed.emit()

func _ready():
	setup_ui()
	%RerollButton.pressed.connect(_reroll)
	%AcceptButton.pressed.connect(close)
	for btn in get_buttons():
		btn.item_selected.connect(item_selected.emit)
	item_selected.connect(_item_selected)
	if get_tree().current_scene == self:
		await modal()
func _reroll():
	money -= 10
	setup_ui()
func _item_selected(shopItem:ShopItemResource):
	if get_parent():
		shopItem.item.apply(get_parent())
	shopItem.quantity -= 1
	if player:
		player.resource.money -= shopItem.price
	else:
		money -= shopItem.price
	if shopItem.quantity<=0:
		swapEmpty()
	
	
