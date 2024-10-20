# mission.gd
extends Resource

class_name Mission

@export var title: String
@export var description: String
@export var npc_name: String  # Emoção necessária do NPC para a missão
@export var is_completed: bool = false  # Estado da missão
@export var reward: String  # Pode ser um item, experiência, etc.

# Método para verificar se a missão está concluída
func check_completion() -> bool:
	if is_completed:
		return true
	return false

# Método para completar a missão
func complete_mission() -> void:
	if not is_completed:
		is_completed = true
		print("Missão completada: ", title)
		give_reward()  # Chama a função de recompensa quando a missão é completada

# Método para dar a recompensa ao jogador
func give_reward() -> void:
	print("Recompensa concedida: ", reward)
	# Adicionar lógica para conceder a recompensa ao jogador (ex: adicionar item, moedas, etc.)
