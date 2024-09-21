# Classe que representa a interface do inventário, herdando de PanelContainer
extends PanelContainer

# Pré-carrega a cena do slot que será utilizado na interface
const Slot = preload("res://InventoryTutorial/Inventory/slot.tscn")

# Referência ao GridContainer onde os slots de itens serão exibidos
@onready var item_grid: GridContainer = $MarginContainer/ItemGrid

# Função que configura os dados do inventário e conecta sinais relevantes
func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_item_grid)  # Conecta o sinal de atualização do inventário
	populate_item_grid(inventory_data)  # Popula o grid com os dados do inventário

# Função que limpa os dados do inventário e desconecta sinais
func clear_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.disconnect(populate_item_grid)  # Desconecta o sinal de atualização

# Função que preenche o grid de itens com os dados do inventário
func populate_item_grid(inventory_data: InventoryData) -> void:
	# Remove todos os slots filhos do item_grid
	for child in item_grid.get_children():
		child.queue_free()
		
	# Adiciona um novo slot para cada SlotData no inventário
	for slot_data in inventory_data.slot_datas:
		var slot = Slot.instantiate()  # Cria uma nova instância de slot
		item_grid.add_child(slot)  # Adiciona o slot ao grid
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)  # Conecta o sinal de clique do slot à função de interação do inventário
		
		if slot_data:
			slot.set_slot_data(slot_data)  # Configura os dados do slot se existirem
