@tool
extends Node
class_name GameMain
var player:Player:
	set(v):
		player=v
		update_refs()

var enemyManager: EnemyManager:
	set(v):
		enemyManager = v
		update_refs()
var weaponsManager: WeaponsManager:
	set(v):
		weaponsManager = v
		update_refs()
var camera: Camera2D:
	set(v):
		camera = v
		update_refs()
var navmesh: NavigationMesh:
	set(v):
		navmesh = v
		update_refs()
var gameUi: GameUi:
	set(v):
		gameUi = v
		update_refs()
var pause_menu: CanvasLayer

func update_refs():
	if gameUi:
		gameUi.player = player
		gameUi.enemyManager = enemyManager
	if player:
		player.weaponsManager = weaponsManager
	
func _ready() -> void:
	child_entered_tree.connect(_child_entered_tree)
	child_exiting_tree.connect(_child_exiting_tree)
	for c in get_children(true):
		_child_entered_tree(c)
	add_child(preload("res://Game/Ui/GameUi/GameUi.tscn").instantiate())
	pause_menu = preload("res://MainMenu/PauseMenu.tscn").instantiate()
	pause_menu.visible = false
	add_child(pause_menu)
	
	
func _child_entered_tree(node:Node):
	if node is Player: 
		player = node
	if node is EnemyManager: 
		enemyManager = node
	if node is WeaponsManager: 
		weaponsManager = node
	if node is Camera2D: 
		camera = node
	if node is GameUi: 
		gameUi = node
func _child_exiting_tree(node:Node):
	if node is Player and player == node: 
		player = node
	if node is EnemyManager and enemyManager == node: 
		enemyManager = node
	if node is WeaponsManager and weaponsManager == node: 
		weaponsManager = node
	if node is Camera2D and camera == node: 
		camera = node
	if node is GameUi and gameUi == node: 
		gameUi = node
	
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return 
	if OS.has_feature("standalone"):
		return
	if player:
		if Input.is_action_just_pressed("dev_player_upgrade"):
			player.show_upgrade_modal()
		if Input.is_action_just_pressed("dev_player_shop"):
			player.show_shop_modal()
		if Input.is_action_just_pressed("dev_player_equip"):
			player.show_equip_modal()
		if Input.is_action_just_pressed("dev_player_size_up"):
			player.resource.stat_size += 1
		if Input.is_action_just_pressed("dev_player_size_down"):
			player.resource.stat_size -= 1
		if Input.is_action_just_pressed("dev_player_die"):
			player.resource.deplete_health()
	if weaponsManager:
		if Input.is_action_just_pressed("dev_weapon_count_up"):
			weaponsManager.dev_add_weapon()
		if Input.is_action_just_pressed("dev_weapon_count_down"):
			weaponsManager.dev_remove_weapon()
	
	if Input.is_action_just_pressed("dev_player_respawn"):
		if player:
			player.queue_free()
		var node:Player = preload("res://Game/Units/Player/Player.tscn").instantiate()
		add_child(node)
		var map_rid = get_viewport().world_2d.navigation_map
		var rand_point = NavigationServer2D.map_get_random_point(map_rid,1,false)
		node.global_position = rand_point
		
	
