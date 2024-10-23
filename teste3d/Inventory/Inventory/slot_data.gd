# Classe que gerencia os dados de um slot de inventário, herdando de Resource
extends Resource

# Define o nome da classe como SlotData para ser utilizada em outros scripts
class_name SlotData

# Constante que define o tamanho máximo de pilha de itens no slot
const MAX_STACK_SIZE: int = 99

# Variáveis exportadas que definem o item e a quantidade presente no slot
@export var item_data: ItemData  # Referência aos dados do item associado a este slot
@export_range(1, MAX_STACK_SIZE) var quantity: int = 1: set = set_quantity  # Quantidade de itens no slot, com valor mínimo de 1 e máximo definido pela constante

# Função que verifica se dois slots podem ser mesclados
func can_merge_with(other_slot_data: SlotData) -> bool:
	# Verifica se os itens são do mesmo tipo, empilháveis e se a quantidade atual é menor que o máximo permitido
	return item_data == other_slot_data.item_data \
			and item_data.stackable \
			and quantity < MAX_STACK_SIZE

# Função que verifica se dois slots podem ser mesclados completamente
func can_fully_merge_with(other_slot_data: SlotData) -> bool:
	# Verifica se os itens são do mesmo tipo, empilháveis e se a soma das quantidades não excede o máximo permitido
	return item_data == other_slot_data.item_data \
			and item_data.stackable \
			and quantity + other_slot_data.quantity <= MAX_STACK_SIZE

# Função que cria um novo SlotData com apenas um item, reduzindo a quantidade do slot original
func create_single_slot_data() -> SlotData:
	var new_slot_data = duplicate()  # Cria uma duplicata do SlotData atual
	new_slot_data.quantity = 1
	quantity -= 1  # Reduz a quantidade do slot original em 1
	return new_slot_data

# Função que mescla completamente outro slot com o atual, somando as quantidades
func fully_merge_with(other_slot_data: SlotData) -> void:
	quantity += other_slot_data.quantity  # Adiciona a quantidade do outro slot à quantidade atual

# Função para definir a quantidade de itens no slot, com validação para itens não empilháveis
func set_quantity(value: int) -> void:
	quantity = value  # Define a quantidade
	
	# Se a quantidade for maior que 1 e o item não for empilhável, ajusta para 1
	if quantity > 1 and !item_data.stackable:
		quantity = 1
