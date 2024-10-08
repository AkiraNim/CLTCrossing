# Classe que gerencia a interface do inventário, herdando de Control
extends Control

# Sinal emitido quando um item é solto, passando os dados do slot
signal drop_slot_data(slot_data: SlotData)

# Variáveis que armazenam os dados do slot atualmente "agarrado" e o dono do inventário externo
var grabbed_slot_data: SlotData  # Dados do slot que está sendo "segurado" pelo jogador
var external_inventory_owner  # Referência ao dono do inventário externo

# Referências aos nós de diferentes inventários e do slot agarrado
@onready var external_inventory: PanelContainer = $ExternalInventory/ExternalInventory  # Inventário externo, exibido quando acessado
@onready var player_inventory: PanelContainer = $PlayerInventory/PlayerInventory  # Inventário do jogador
@onready var grabbed_slot: PanelContainer = $GrabbedSlot  # Slot visual que segue o mouse quando um item é agarrado
@onready var equip_inventory: PanelContainer = $PlayerInventory/EquipInventory  # Inventário de equipamentos do jogador
@onready var item_descripition: Label = $"../InventoryDescription/ItemDescripition"
@onready var inventory_description: CanvasLayer = $"../InventoryDescription"
@onready var player_inventory_node: Node2D = $PlayerInventory
@onready var external_inventory_node: Node2D = $ExternalInventory


# Função chamada a cada quadro de física, atualiza a posição do slot agarrado para seguir o mouse
func _physics_process(delta: float) -> void:
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5, 5)  # Desloca o slot para a posição do mouse
	if inventory_description.visible:
		player_inventory_node.hide()
		external_inventory_node.hide()
	elif !inventory_description.visible:
		player_inventory_node.show()
		
# Função que define os dados do inventário do jogador e conecta a interação do inventário
func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)  # Conecta o sinal de interação
	player_inventory.set_inventory_data(inventory_data)  # Define os dados no inventário do jogador

# Função que define os dados do inventário de equipamentos
func set_equip_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	equip_inventory.set_inventory_data(inventory_data)

# Função que define os dados do inventário externo e o exibe
func set_external_inventory(_external_inventory_owner) -> void:
	external_inventory_owner = _external_inventory_owner
	var inventory_data = external_inventory_owner.inventory_data
	
	inventory_data.inventory_interact.connect(on_inventory_interact)
	external_inventory.set_inventory_data(inventory_data)
	
	external_inventory_node.show()

# Função que limpa e esconde o inventário externo
func clear_external_inventory() -> void:
	if external_inventory_owner:
		var inventory_data = external_inventory_owner.inventory_data
		
		inventory_data.inventory_interact.disconnect(on_inventory_interact)
		external_inventory.clear_inventory_data(inventory_data)
		
		external_inventory_node.hide()
		external_inventory_owner = null

# Função chamada quando há interação com o inventário
func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
	var description: String
	# Realiza ações com base nos dados do slot agarrado e o botão pressionado
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)  # Agarra o item do slot
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)  # Solta o item no slot
		[null, MOUSE_BUTTON_RIGHT]:
			description = inventory_data.get_slot_data_description(index, description)  # Usa o item do slot
			item_descripition.text = description
			inventory_description.show()
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)  # Solta um único item no slot
	
	update_grabbed_slot()  # Atualiza o estado do slot agarrado

# Função que atualiza o estado visual do slot agarrado
func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)  # Atualiza os dados do slot agarrado
	else:
		grabbed_slot.hide()  # Esconde o slot agarrado se não houver dados

# Função que lida com a entrada de eventos no GUI, como cliques do mouse
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and event.is_pressed() \
			and grabbed_slot_data:
				
		# Verifica qual botão do mouse foi clicado e emite o sinal de soltar o item
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				drop_slot_data.emit(grabbed_slot_data)  # Solta o item agarrado
				grabbed_slot_data = null
			MOUSE_BUTTON_RIGHT:
				drop_slot_data.emit(grabbed_slot_data.create_single_slot_data())  # Solta um único item
				if grabbed_slot_data.quantity < 1:
					grabbed_slot_data = null
		update_grabbed_slot()  # Atualiza o estado do slot agarrado

# Função chamada quando a visibilidade da interface muda
func _on_visibility_changed() -> void:
	if !visible and grabbed_slot_data:
		drop_slot_data.emit(grabbed_slot_data)  # Solta o item se a interface for escondida
		grabbed_slot_data = null
		update_grabbed_slot()
