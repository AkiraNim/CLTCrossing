# Classe que representa um baú no jogo, herdando de StaticBody3D
extends StaticBody3D

# Sinal que é emitido quando o inventário do baú é ativado ou desativado
signal toggle_inventory(external_inventory_owner)

# Variável exportada que contém os dados do inventário do baú
@export var inventory_data: InventoryData
@export var name_type: String
@export var price: float

@onready var external_inventory_label: Label = $"../Ui/InventoryInterface/ExternalInventory/ExternalInventoryLabel"

# Função chamada quando o jogador interage com o baú
func player_interact() -> void:
	toggle_inventory.emit(self)  # Emite o sinal para alternar a exibição do inventário, passando a instância do baú
	external_inventory_label.text = name_type
