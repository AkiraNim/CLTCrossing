# Classe que representa os dados do inventário, herdando de Resource
extends Resource
class_name InventoryData

# Sinais que permitem a comunicação sobre mudanças no inventário
signal inventory_updated(inventory_data: InventoryData)  # Emitido quando o inventário é atualizado
signal inventory_interact(inventory_data: InventoryData, index: int, button: int)  # Emitido quando há interação com um slot do inventário

# Variável exportada que contém os dados dos slots do inventário
@export var slot_datas: Array[SlotData]  # Array que armazena os dados dos slots


# Função que agarra os dados de um slot no índice especificado
func grab_slot_data(index: int) -> SlotData:
	var slot_data = slot_datas[index]  # Obtém os dados do slot no índice

	if slot_data:
		slot_datas[index] = null  # Limpa o slot após agarrar
		inventory_updated.emit(self)  # Emite sinal de atualização do inventário
		return slot_data  # Retorna os dados do slot agarrado
	else:
		return null  # Retorna nulo se o slot estiver vazio

# Função que solta os dados do slot agarrado em um slot específico
func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]  # Obtém os dados do slot no índice

	var return_slot_data: SlotData
	# Verifica se os dados do slot existem e se podem ser mesclados com o item agarrado
	if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data)  # Mescla os dados dos slots
	else:
		slot_datas[index] = grabbed_slot_data  # Define o slot no índice com os dados agarrados
		return_slot_data = slot_data  # Armazena os dados do slot original

	inventory_updated.emit(self)  # Emite sinal de atualização do inventário
	return return_slot_data  # Retorna os dados do slot original, se houver

# Função que solta um único item do slot agarrado em um slot específico
func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data = slot_datas[index]  # Obtém os dados do slot no índice

	if !slot_data:
		slot_datas[index] = grabbed_slot_data.create_single_slot_data()  # Cria e adiciona um único item ao slot
	elif slot_data.can_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())  # Mescla um único item

	inventory_updated.emit(self)  # Emite sinal de atualização do inventário
	if grabbed_slot_data.quantity > 0:
		grabbed_slot_data
		return grabbed_slot_data  # Retorna os dados do slot agarrado se ainda houver quantidade
	else:
		return null  # Retorna nulo se não houver quantidade

# Função que tenta pegar os dados de um slot e mesclá-los com o novo slot
func pick_up_slot_data(slot_data: SlotData) -> bool:
	# Tenta mesclar com um slot existente
	for index in slot_datas.size():
		if slot_datas[index] and slot_datas[index].can_fully_merge_with(slot_data):
			slot_datas[index].fully_merge_with(slot_data)  # Mescla os dados
			inventory_updated.emit(self)  # Emite sinal de atualização
			return true  # Retorna verdadeiro se a mesclagem foi bem-sucedida

	# Tenta encontrar um slot vazio para adicionar o novo slot
	for index in slot_datas.size():
		if !slot_datas[index]:
			slot_datas[index] = slot_data  # Adiciona o novo slot
			inventory_updated.emit(self)  # Emite sinal de atualização
			return true  # Retorna verdadeiro se o slot foi adicionado

	return false  # Retorna falso se não conseguiu adicionar ou mesclar

# Função que usa o item de um slot específico
func use_slot_data(index: int) -> void:
	var slot_data = slot_datas[index]  # Obtém os dados do slot no índice
	if !slot_data:
		return  # Retorna se o slot estiver vazio

	if slot_data.item_data is ItemDataConsumable:
		slot_data.quantity -= 1  # Reduz a quantidade do item
		if slot_data.quantity < 1:
			slot_datas[index] = null  # Remove o slot se a quantidade chegar a zero

	PlayerManager.use_slot_data(slot_data)  # Chama a função de uso do PlayerManager

	inventory_updated.emit(self)  # Emite sinal de atualização do inventário

# Função chamada quando um slot é clicado
func on_slot_clicked(index: int, button: int) -> void:
	inventory_interact.emit(self, index, button)  # Emite sinal de interação, passando os dados do slot e o botão pressionado
	
func get_slot_data_index_by_name(name: String)->int:
	var index: int
	for i in range (slot_datas.size()):
		if get_slot_data_name(i) != "":
			index = i
	return index

func get_slot_data_description(index: int, description: String) -> String:
	var slot_data = slot_datas[index]  # Obtém os dados do slot no índice
	if !slot_data:
		return  ""
	description = slot_data.item_data.description
	return description

func get_slot_data_name(index: int) -> String:
	var slot_data = slot_datas[index]  # Obtém os dados do slot no índice
	if !slot_data:
		return  ""
	return slot_data.item_data.name

func get_slot_data_item(index: int) -> ItemData:
	var slot_data = slot_datas[index]  # Obtém os dados do slot no índice
	if !slot_data:
		return null  # Retorna nulo se o slot estiver vazio
	return slot_data.item_data  # Retorna o item armazenado no slot

func get_slot_data_quantity(index: int) -> int:
	var slot_data = slot_datas[index]
	return slot_data.quantity

func can_pick_up_item(item_data: ItemData) -> bool:
	if item_data.unique:
	# Verifica se o item único já existe no inventário
		for slot_data in slot_datas:
			if slot_data and slot_data.item_data == item_data:
				return false  # O item já está no inventário, não pode pegar de novo
	return true  # Caso contrário, permite pegar o item
#quando o usuario dropa um unico item de um monte de items, queria que esse unico item tivesse um index diferente
