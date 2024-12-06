# Classe que herda de InventoryData, especializada para gerenciar dados de inventário de equipamentos
extends InventoryData

# Define o nome da classe como InventoryDataEquip para ser utilizada em outros scripts
class_name InventoryDataEquip

# Função que solta os dados do slot agarrado em um slot específico do inventário
func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	# Verifica se o item agarrado não é do tipo ItemDataEquip
	if !grabbed_slot_data.item_data is ItemDataEquip:
		return grabbed_slot_data  # Retorna os dados do slot sem modificações
	
	# Chama a função da classe pai para soltar os dados do slot, se for um ItemDataEquip
	return super.drop_slot_data(grabbed_slot_data, index)

# Função que solta um único item do slot agarrado em um slot específico do inventário
func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	# Verifica se o item agarrado não é do tipo ItemDataEquip
	if !grabbed_slot_data.item_data is ItemDataEquip:
		return grabbed_slot_data  # Retorna os dados do slot sem modificações
	
	# Chama a função da classe pai para soltar um único item do slot, se for um ItemDataEquip
	return super.drop_single_slot_data(grabbed_slot_data, index)
