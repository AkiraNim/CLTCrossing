# Classe que gerencia a interface do inventário, herdando de Control
extends Control

# Sinal emitido quando um item é solto, passando os dados do slot
signal drop_slot_data(slot_data: SlotData)

# Variável para rastrear se o item foi retirado do inventário externo
var grabbed_from_external = false  

# Variáveis que armazenam os dados do slot atualmente "agarrado" e o dono do inventário externo
var grabbed_slot_data: SlotData  # Dados do slot que está sendo "segurado" pelo jogador
var external_inventory_owner  # Referência ao dono do inventário externo
var external_inventory_opened: bool = false  # Flag para verificar se o inventário externo está aberto
var visible_external_inventory: bool = false  # Flag para controlar a visibilidade do inventário externo

# Referências aos nós de diferentes inventários e do slot agarrado
@onready var external_inventory: PanelContainer = $ExternalInventory/ExternalInventory  # Inventário externo
@onready var player_inventory: PanelContainer = $PlayerInventory/PlayerInventory  # Inventário do jogador
@onready var grabbed_slot: PanelContainer = $GrabbedSlot  # Slot visual que segue o mouse quando um item é agarrado
@onready var equip_inventory: PanelContainer = $PlayerInventory/EquipInventory  # Inventário de equipamentos do jogador
@onready var inventory_description: CanvasLayer = $"../InventoryDescription"  # Descrição do item exibida no inventário
@onready var player_inventory_node: Node2D = $PlayerInventory  # Nodo do inventário do jogador
@onready var external_inventory_node: Node2D = $ExternalInventory  # Nodo do inventário externo
@onready var item_name: Label = $"../InventoryDescription/ItemName"  # Nome do item
@onready var item_description: RichTextLabel = $"../InventoryDescription/ItemDescription"  # Descrição do item
@onready var books: PanelContainer = $PlayerInventory/Books
@onready var panel_container: PanelContainer = $PanelContainer

# Função chamada a cada quadro de física, atualiza a posição do slot agarrado para seguir o mouse
func _physics_process(delta: float) -> void:
	if grabbed_slot.visible:
		# Atualiza a posição do slot agarrado para seguir o mouse com um pequeno deslocamento
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5, 5)
	
	# Gerencia a visibilidade do inventário e da descrição
	if inventory_description.visible:
		if external_inventory_node.visible:
			visible_external_inventory = true
		player_inventory_node.hide()  # Esconde o inventário do jogador
		external_inventory_node.hide()  # Esconde o inventário externo
	elif !inventory_description.visible:
		# Mostra o inventário do jogador e o externo, se necessário
		player_inventory_node.show()
		if visible_external_inventory:
			visible_external_inventory = false
			external_inventory_node.show()
	if player_inventory_node.visible:
		panel_container.show()
	else:
		panel_container.hide()
# Define os dados do inventário do jogador e conecta a interação do inventário
func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)  # Conecta o sinal de interação do inventário
	player_inventory.set_inventory_data(inventory_data)  # Define os dados no inventário do jogador

# Define os dados do inventário de equipamentos
func set_equip_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)  # Conecta o sinal de interação do inventário
	equip_inventory.set_inventory_data(inventory_data)  # Define os dados no inventário de equipamentos
func set_books(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	books.set_inventory_data(inventory_data)
# Define os dados do inventário externo e o exibe

# Função chamada quando há interação no inventário
func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
	# Verifica se o inventário em interação é o inventário externo
	var is_external_inventory = external_inventory_owner != null\
	and inventory_data == external_inventory_owner.inventory_data
	
	# Realiza ações com base nos dados do slot agarrado e o botão pressionado
	match [grabbed_slot_data, button]:

		[null, MOUSE_BUTTON_RIGHT]:
			# Jogador está mostrando a descrição do item
			var description: String
			description = inventory_data.get_slot_data_description(index, description)
			if description != "":
				item_description.text = description
				var name: String
				name = inventory_data.get_slot_data_name(index)
				item_name.text = name
				inventory_description.show()  # Exibe a descrição do item
		

	# Atualiza o estado do slot agarrado
	update_grabbed_slot()

# Função que atualiza o estado visual do slot agarrado
func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()  # Exibe o slot agarrado
		grabbed_slot.set_slot_data(grabbed_slot_data)  # Atualiza os dados do slot agarrado
	else:
		grabbed_slot.hide()  # Esconde o slot se não houver item agarrado

# Função que lida com a entrada de eventos no GUI, como cliques do mouse
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and grabbed_slot_data:
		# Verifica qual botão do mouse foi clicado e emite o sinal de soltar o item
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if grabbed_slot_data.item_data.droppable:
					# Solta o item agarrado
					drop_slot_data.emit(grabbed_slot_data)
					grabbed_slot_data = null
			MOUSE_BUTTON_RIGHT:
				if grabbed_slot_data.item_data.droppable:
					# Solta um único item do slot
					drop_slot_data.emit(grabbed_slot_data.create_single_slot_data())
					if grabbed_slot_data.quantity < 1:
						grabbed_slot_data = null
		# Atualiza o estado do slot agarrado
		update_grabbed_slot()

# Função chamada quando a visibilidade da interface muda
func _on_visibility_changed() -> void:
	if ! visible and grabbed_slot_data:
		# Solta o item se a interface for escondida
		if grabbed_slot_data.item_data.droppable:
			drop_slot_data.emit(grabbed_slot_data)
			grabbed_slot_data = null
		update_grabbed_slot()  # Atualiza o estado do slot agarrado
