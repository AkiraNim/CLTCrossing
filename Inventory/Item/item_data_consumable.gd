# Classe que herda de ItemData e define dados específicos para itens consumíveis
extends ItemData

# Define o nome da classe como ItemDataConsumable, permitindo que ela seja reconhecida por outros scripts
class_name ItemDataConsumable

# Variável exportada que define o valor de cura do item consumível
@export var heal_value: int  # Valor inteiro que representa o quanto o item pode curar

# Função que define a lógica de uso do item consumível em um alvo específico
func use(target) -> void:
	# Verifica se o valor de cura não é zero
	if heal_value != 0:
		# Aplica a cura ao alvo chamando o método 'heal' com o valor de cura
		target.heal(heal_value)
