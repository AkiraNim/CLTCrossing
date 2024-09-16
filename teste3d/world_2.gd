extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var inventory_interface: Control = $UI/InventoryInterface

func _ready() -> void:
	
	inventory_interface.set_player_inventory_data(player.inventory_data)
