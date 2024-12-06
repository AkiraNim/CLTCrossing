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
var timer = Timer.new()

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
@onready var color_rect: ColorRect = $"../ColorRect"
@onready var inventory_interface: Control = $"."
@onready var money_label: Label = $PlayerInventory/MoneyLabel
@onready var pop_up: Control = $"../PopUp"
@onready var mission_rich_label: RichTextLabel = $PlayerInventory/MissionRichLabel


# Função chamada a cada quadro de física, atualiza a posição do slot agarrado para seguir o mouse
func _physics_process(delta: float) -> void:
	if grabbed_slot.visible:
		# Atualiza a posição do slot agarrado para seguir o mouse com um pequeno deslocamento
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5, 5)
	
	# Gerencia a visibilidade do inventário e da descrição
	if inventory_description.visible:
		if external_inventory_node.visible:
			visible_external_inventory = true
		color_rect.hide()
		player_inventory_node.hide()  # Esconde o inventário do jogador
		external_inventory_node.hide()  # Esconde o inventário externo
	elif !inventory_description.visible:
		# Mostra o inventário do jogador e o externo, se necessário
		player_inventory_node.show()
		color_rect.show()
		if visible_external_inventory:
			visible_external_inventory = false
			external_inventory_node.show()
	if inventory_interface.visible:
		money_label.text = "R$%.2f" % [PlayerManager.player.money]
		color_rect.show()
	elif !inventory_interface.visible:
		money_label.text = ""
		color_rect.hide()
	var missions_string : String
	for missions in MissionManager.get_available_missions():
		if missions && missions.title !="":
			missions_string += missions.title
			missions_string += "\n"
			missions_string += "Descrição: "
			missions_string += missions.description
			missions_string += "\n"
			missions_string += "Recompensa: "
			missions_string += missions.reward
			missions_string += "\n\n"
	mission_rich_label.text = missions_string

# Define os dados do inventário do jogador e conecta a interação do inventário
func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)  # Conecta o sinal de interação do inventário
	player_inventory.set_inventory_data(inventory_data)  # Define os dados no inventário do jogador

# Define os dados do inventário de equipamentos
func set_equip_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)  # Conecta o sinal de interação do inventário
	equip_inventory.set_inventory_data(inventory_data)  # Define os dados no inventário de equipamentos

# Define os dados do inventário externo e o exibe
func set_external_inventory(_external_inventory_owner) -> void:
	external_inventory_owner = _external_inventory_owner  # Define o dono do inventário externo
	var inventory_data = external_inventory_owner.inventory_data
	
	# Verifica e remove itens únicos que o jogador já possui
	for i in range(inventory_data.slot_datas.size()):
		if inventory_data.slot_datas[i] != null:
			if PlayerManager.player.player_have_this_item(inventory_data.slot_datas[i].item_data)\
			and inventory_data.slot_datas[i].item_data != null\
			and inventory_data.slot_datas[i].item_data.unique:
				inventory_data.slot_datas[i] = null

	# Bubble Sort para mover slots nulos para o final
	for i in range(inventory_data.slot_datas.size()):
		for j in range(inventory_data.slot_datas.size() - i - 1):
			if inventory_data.slot_datas[j] == null and inventory_data.slot_datas[j + 1] != null:
				# Troca slots nulo e não-nulo para mover os nulos para o final
				var temp = inventory_data.slot_datas[j]
				inventory_data.slot_datas[j] = inventory_data.slot_datas[j + 1]
				inventory_data.slot_datas[j + 1] = temp

	# Bubble Sort para organizar slots não nulos em ordem alfabética
	for i in range(inventory_data.slot_datas.size()):
		for j in range(inventory_data.slot_datas.size() - i - 1):
			# Verifica se ambos os slots são não nulos para comparar
			var current_slot = inventory_data.slot_datas[j]
			var next_slot = inventory_data.slot_datas[j + 1]
			
			if current_slot != null and next_slot != null:
				if current_slot.item_data.name > next_slot.item_data.name:
					# Troca slots para organizar em ordem alfabética
					var temp = inventory_data.slot_datas[j]
					inventory_data.slot_datas[j] = inventory_data.slot_datas[j + 1]
					inventory_data.slot_datas[j + 1] = temp
	
	inventory_data.inventory_interact.connect(on_inventory_interact)  # Conecta a interação do inventário externo
	external_inventory.set_inventory_data(inventory_data)  # Define os dados do inventário externo
	
	external_inventory_node.show()  # Exibe o inventário externo
	external_inventory_opened = true  # Marca que o inventário externo está aberto

# Limpa e oculta o inventário externo
func clear_external_inventory() -> void:
	if external_inventory_owner:
		var inventory_data = external_inventory_owner.inventory_data
		
		inventory_data.inventory_interact.disconnect(on_inventory_interact)  # Desconecta a interação do inventário
		external_inventory.clear_inventory_data(inventory_data)  # Limpa os dados do inventário externo
		
		external_inventory_node.hide()  # Esconde o inventário externo
		external_inventory_owner = null  # Remove a referência ao dono do inventário externo
		external_inventory_opened = false  # Marca que o inventário externo está fechado

# Função chamada quando há interação no inventário
func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
	# Verifica se o inventário em interação é o inventário externo
	var is_external_inventory = external_inventory_owner != null\
	and inventory_data == external_inventory_owner.inventory_data
	
	# Realiza ações com base nos dados do slot agarrado e o botão pressionado
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			# Jogador está retirando um item do inventário
			grabbed_slot_data = inventory_data.grab_slot_data(index)
			if grabbed_slot_data != null:
				if is_external_inventory:
					# Item retirado do inventário externo (para venda)
					grabbed_from_external = true  # Marca que o item foi retirado do inventário externo
				else:
					# Item retirado do inventário do jogador
					grabbed_from_external = false  # Marca que o item foi retirado do inventário do jogador
			
		[_, MOUSE_BUTTON_LEFT]:
			# Jogador está colocando um item no inventário
			if grabbed_slot_data:
				if is_external_inventory and external_inventory_owner.is_in_group("Selling"):
					# Colocando item no inventário externo (venda)
					if ! grabbed_from_external:
						# Jogador ganha dinheiro ao vender o item
						var price: float = grabbed_slot_data.item_data.price * grabbed_slot_data.quantity
						PlayerManager.player.add_money(price)
						pop_up.set_popup_text("Item %s vendido.\n+R$%.2f\n-%d" % [grabbed_slot_data.item_data.name, price, grabbed_slot_data.quantity], 2.0)
					grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
				else:
					# Colocando item no inventário do jogador (compra)
					if grabbed_from_external:
						# Jogador perde dinheiro ao comprar o item
						var price: float = grabbed_slot_data.item_data.price * grabbed_slot_data.quantity
						PlayerManager.player.add_money(-price)
						pop_up.set_popup_text("Item %s comprado.\n-R$%.2f\n+%d" % [grabbed_slot_data.item_data.name, price, grabbed_slot_data.quantity], 2.0)
					grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
		
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
		
		[_, MOUSE_BUTTON_RIGHT]:
			# Jogador está soltando um único item no slot
			if grabbed_slot_data:
				if is_external_inventory and external_inventory_owner.is_in_group("Selling"):
					# Solta um único item no inventário externo (venda)
					if ! grabbed_from_external:
						var price: float = grabbed_slot_data.item_data.price
						PlayerManager.player.add_money(price)
						pop_up.set_popup_text("Item %s vendido.\n+R$%.2f\n-%d" % [grabbed_slot_data.item_data.name, price, 1], 2.0)
					grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)
				else:
					# Solta um único item no inventário do jogador (compra)
					if grabbed_from_external:
						var price: float = grabbed_slot_data.item_data.price
						PlayerManager.player.add_money(-price)
						pop_up.set_popup_text("Item %s comprado.\n-R$%.2f\n+%d" % [grabbed_slot_data.item_data.name, price, 1], 2.0)
					grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)
	
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
					pop_up.set_popup_text("Item %s dropado.\n-%d" % [grabbed_slot_data.item_data.name, grabbed_slot_data.quantity], 2.0)
					grabbed_slot_data = null
			MOUSE_BUTTON_RIGHT:
				if grabbed_slot_data.item_data.droppable:
					# Solta um único item do slot
					drop_slot_data.emit(grabbed_slot_data.create_single_slot_data())
					pop_up.set_popup_text("Item %s dropado.\n-%d" % [grabbed_slot_data.item_data.name, 1], 2.0)
					if grabbed_slot_data.quantity < 1:
						grabbed_slot_data = null
		# Atualiza o estado do slot agarrado
		update_grabbed_slot()
# Função chamada quando a visibilidade da interface muda
func _on_visibility_changed() -> void:
	if ! visible and grabbed_slot_data:
		# Solta o item se a interface for escondida
		if grabbed_slot_data.item_data.droppable:
			PlayerManager.player.inventory_data.pick_up_slot_data(grabbed_slot_data)
			grabbed_slot_data = null
		update_grabbed_slot()  # Atualiza o estado do slot agarrado
