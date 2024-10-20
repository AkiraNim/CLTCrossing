# mission_manager.gd
extends Node

# Lista de todas as missões disponíveis no jogo
var missions: Array = []

# Adiciona uma nova missão ao sistema
func add_mission(mission: Mission) -> void:
	missions.append(mission)
	print("Nova missão adicionada: ", mission.title)

# Retorna uma lista de missões disponíveis com base na emoção
func get_available_missions(emotion: int) -> Array:
	var available_missions = []
	for mission in missions:
		if not mission.is_completed and mission.emotion_requirement == emotion:
			available_missions.append(mission)
	return available_missions
