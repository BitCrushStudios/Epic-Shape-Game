extends Resource


@export var player:PlayerResource
@export var weapons: Array[WeaponResource]

signal enemy_added(enemy:Enemy)
signal enemy_removed(enemy:Enemy)
signal enemy_spawner_added(enemy:Enemy)
signal enemy_spawner_removed(enemy:Enemy)
signal player_added(player:Player)
signal player_removed(player:Player)
signal wave_started()
signal wave_ended()
signal weapon_added(weapon:Weapon)
signal weapon_removed(weapon:Weapon)
