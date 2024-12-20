# Classe que gerencia o comportamento de um slot de inventário, herdando de PanelContainer
extends PanelContainer

# Sinal que é emitido quando o slot é clicado, passando o índice do slot e o botão do mouse
signal slot_clicked(index: int, button: int)

# Referências aos nós internos do slot
@onready var texture_rect: TextureRect = $MarginContainer/TextureRect  # Referência ao nó que exibe a textura do item
@onready var quantity_label: Label = $QuantityLabel  # Referência ao rótulo que exibe a quantidade de itens

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS  # Garante que o slot detecte eventos de mouse
	
# Função que define os dados do slot, atualizando a aparência e tooltip
func set_slot_data(slot_data: SlotData) -> void:
	var item_data = slot_data.item_data  # Obtém os dados do item do slot

	
	# Verifica se item_data é válido (não null)
	if item_data != null:
		texture_rect.texture = item_data.texture  # Define a textura do item no slot
		tooltip_text = "%s\n%s\nR$%.2f" % [item_data.name, item_data.tooltip, item_data.price]  # Define o texto do tooltip com o nome e a descrição do item
		# Atualiza o rótulo de quantidade com o número de itens, se for maior ou igual a 1
		if slot_data.quantity >= 1:
			quantity_label.text = "x%s" % slot_data.quantity  # Exibe a quantidade de itens
			quantity_label.show()  # Mostra o rótulo de quantidade
		else:
			quantity_label.hide()  # Esconde o rótulo de quantidade se a quantidade for menor que 1
	else:
		# Se o item_data for null, limpa a textura e esconde o rótulo de quantidade
		texture_rect.texture = null  # Remove a textura do item
		tooltip_text = ""  # Remove o tooltip
		quantity_label.hide()  # Esconde o rótulo de quantidade

# Função que responde a eventos de entrada do GUI, como cliques do mouse
func _on_gui_input(event: InputEvent) -> void:
	# Verifica se o evento é um clique de botão do mouse (esquerdo ou direito) e se está pressionado
	if event is InputEventMouseButton \
			and (event.button_index == MOUSE_BUTTON_LEFT \
			or event.button_index == MOUSE_BUTTON_RIGHT) \
			and event.is_pressed():
		# Emite o sinal slot_clicked passando o índice do slot e o botão do mouse que foi clicado
		slot_clicked.emit(get_index(), event.button_index)
# Conecta o sinal ao método de clique do inventário
