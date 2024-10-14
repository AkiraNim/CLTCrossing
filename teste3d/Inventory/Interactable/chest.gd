# Classe que representa um baú no jogo, herdando de StaticBody3D
extends StaticBody3D

# Sinal que é emitido quando o inventário do baú é ativado ou desativado
signal toggle_inventory(external_inventory_owner)

# Variável exportada que contém os dados do inventário do baú
@export var inventory_data: InventoryData
@onready var animation_player: AnimationPlayer = $chest2/AnimationPlayer
@onready var external_inventory_node: Node2D = $"../Ui/InventoryInterface/ExternalInventory"
@onready var external_inventory_label: Label = $"../Ui/InventoryInterface/ExternalInventory/ExternalInventoryLabel"

@export var name_type: String

# Função chamada quando o jogador interage com o baú
func _ready() -> void:
	animation_player.play("closed")
	
func player_interact() -> void:
	toggle_inventory.emit(self)  # Emite o sinal para alternar a exibição do inventário, passando a instância do baú
	external_inventory_label.text = name_type
	
	if external_inventory_node.visible:
		animation_player.play("open")
	elif !external_inventory_node.visible:
		animation_player.play("close")
		
func is_interactible() -> bool:
	return true;
