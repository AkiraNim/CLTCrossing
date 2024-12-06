# Esta classe herda de ItemData e é usada para definir dados específicos de um item de equipamento
extends ItemData

# Define o nome da classe como ItemDataEquip, permitindo que ela seja reconhecida em outros scripts
class_name ItemDataEquip

# Variável exportada que define o valor de defesa do item
@export var defence: int  # Valor inteiro que representa a defesa fornecida pelo equipamento
