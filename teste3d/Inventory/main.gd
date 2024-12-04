# Classe principal que herda de Node
extends Node

# Carrega o arquivo de cena para o item que pode ser pego
const PickUp = preload("res://Inventory/Item/PickUp/pick_up.tscn")

# Declaração de variáveis com os nós referenciados
@onready var player: CharacterBody3D = $Player  # Referência ao nó do jogador
@onready var inventory_interface: Control = $Ui/InventoryInterface  # Interface do inventário
@onready var hot_bar_inventory: PanelContainer = $Ui/HotBarInventory  # Barra de inventário rápido


# Função que é executada quando o nó está pronto
func _ready() -> void:
	# Conecta o sinal de alternância do inventário do jogador à função de alternância de interface
	player.toggle_inventory.connect(toggle_inventory_interface)
	# Define os dados do inventário do jogador na interface
	inventory_interface.set_player_inventory_data(player.inventory_data)
	# Define os dados de inventário de equipamentos na interface
	inventory_interface.set_equip_inventory_data(player.equip_inventory_data)
	# Define os dados do inventário na barra de inventário rápido
	# Conecta a função de alternância para todos os inventários externos no grupo "external_inventory"
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)
	SaveLoad.load_game()
# Função que alterna a visibilidade da interface do inventário

func toggle_inventory_interface(external_inventory_owner = null) -> void:
	# Alterna a visibilidade da interface do inventário
	inventory_interface.visible = not inventory_interface.visible
	
	# Configura o modo do mouse e visibilidade da barra de inventário rápido
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE  # Mostra o cursor do mouse
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED  # Captura o cursor do mouse para o jogo
	
	# Configura o inventário externo se houver um proprietário externo e a interface estiver visível
	if external_inventory_owner and inventory_interface.visible:
		inventory_interface.set_external_inventory(external_inventory_owner)
	else:
		inventory_interface.clear_external_inventory()  # Limpa o inventário externo

# Função que é chamada quando um item é solto na interface do inventário
func _on_inventory_interface_drop_slot_data(slot_data: SlotData) -> void:
	# Cria uma nova instância do item a ser pego
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data  # Define os dados do slot para o item a ser pego
	pick_up.position = player.get_drop_position()  # Define a posição do item no mundo
	add_child(pick_up)  # Adiciona o item como um filho deste nó
