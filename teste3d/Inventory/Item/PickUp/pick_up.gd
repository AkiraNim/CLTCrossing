extends RigidBody3D

@export var slot_data: SlotData
@onready var sprite_3d: Sprite3D = $Sprite3D

func _ready() -> void:
	sprite_3d.texture = slot_data.item_data.texture
	
func _physics_process(delta: float) -> void:
	sprite_3d.rotate_y(delta)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		var item_data = slot_data.item_data
		if ! PlayerManager.player.player_have_this_item(item_data):  # Usa a função para verificar se o jogador já tem o item
			if body.inventory_data.pick_up_slot_data(slot_data):  # Adiciona o item ao inventário
				queue_free()  # Remove o item do mundo
