# Classe que representa a barra de atalho do inventário, herdando de PanelContainer
extends PanelContainer

# Sinal que é emitido quando um item na barra é utilizado
signal hot_bar_use(index: int)

# Pré-carrega a cena do slot que será utilizado na barra
const Slot = preload("res://InventoryTutorial/Inventory/slot.tscn")

# Referência ao HBoxContainer onde os slots da barra de atalho serão exibidos
@onready var h_box_container: HBoxContainer = $MarginContainer/HBoxContainer

# Função chamada para lidar com entradas de teclas não tratadas
func _unhandled_key_input(event: InputEvent) -> void:
	# Verifica se a barra está visível e se a tecla foi pressionada
	if !visible or !event.is_pressed():
		return
	
	# Verifica se a tecla pressionada está dentro do intervalo de 1 a 7
	if range(KEY_1, KEY_7).has(event.keycode):
		hot_bar_use.emit(event.keycode - KEY_1)  # Emite o sinal com o índice correspondente da tecla

# Função que configura os dados do inventário e conecta sinais relevantes
func set_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_updated.connect(populate_hot_bar)  # Conecta o sinal de atualização do inventário
	populate_hot_bar(inventory_data)  # Popula a barra de atalho com os dados do inventário
	hot_bar_use.connect(inventory_data.use_slot_data)  # Conecta o sinal de uso da barra ao método de uso do inventário

# Função que preenche a barra de atalho com os dados do inventário
func populate_hot_bar(inventory_data: InventoryData) -> void:
	# Remove todos os slots filhos do h_box_container
	for child in h_box_container.get_children():
		child.queue_free()
		
	# Adiciona um novo slot para cada SlotData nos primeiros 6 slots do inventário
	for slot_data in inventory_data.slot_datas.slice(0, 6):
		var slot = Slot.instantiate()  # Cria uma nova instância de slot
		h_box_container.add_child(slot)  # Adiciona o slot à barra
		
		if slot_data:
			slot.set_slot_data(slot_data)  # Configura os dados do slot se existirem
