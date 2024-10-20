# Classe que representa um baú no jogo, herdando de StaticBody3D
extends StaticBody3D

# Sinal que é emitido quando o inventário do baú é ativado ou desativado
signal toggle_inventory(external_inventory_owner)

# Variável exportada que contém os dados do inventário do baú
@export var inventory_data: InventoryData
@onready var animation_player: AnimationPlayer = $chest2/AnimationPlayer
@onready var external_inventory_label: Label = $"../../Ui/InventoryInterface/ExternalInventory/ExternalInventoryLabel"
@onready var external_inventory_node: Node2D = $"../../Ui/InventoryInterface/ExternalInventory"

@export var name_type: String

# Função chamada quando o jogador interage com o baú
func _ready() -> void:
	ExternalInventoryManager.external_inventory = self
	animation_player.play("closed")
	
func player_interact() -> void:
	toggle_inventory.emit(self)  # Emite o sinal para alternar a exibição do inventário, passando a instância do baú
	external_inventory_label.text = name_type
	
	if external_inventory_node.visible:
		animation_player.play("open")
	elif !external_inventory_node.visible:
		animation_player.play("close")
		
func external_inventory_have_this_item(item_data: ItemData)-> bool:
	for i in range(ExternalInventoryManager.external_inventory.inventory_data.slot_datas.size()):
		if ExternalInventoryManager.external_inventory.inventory_data.get_slot_data_name(i, item_data.name) == item_data.name\
			and item_data.unique:
			return true
	return false
