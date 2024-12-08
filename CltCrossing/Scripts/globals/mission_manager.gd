extends Node

# Lista de todas as missões disponíveis no jogo
var missions: Array = []

# Adiciona uma nova missão ao sistema
func add_mission(mission: Mission, npc_id: int) -> void:
# Confirma que o nome do NPC é válido (se necessário)
	if mission.npc_id == npc_id:
		missions.append(mission)
	else:
		pass

# Retorna uma lista de missões disponíveis com base no estado de conclusão
func get_available_missions() -> Array:
	var available_missions = []
	for mission in missions:
		if !mission.is_completed:
			available_missions.append(mission)
	return available_missions

# Cria uma nova missão e a adiciona ao sistema
func create_new_mission(npc_id: int, mission_title: String, mission_description: String, mission_reward: String) -> bool:

# Cria a nova missão usando o recurso
	var new_mission = ResourceLoader.load("res://Mission/mission.gd").new()
	new_mission.title = mission_title
	new_mission.description = mission_description
	new_mission.npc_id = npc_id
	new_mission.reward = mission_reward

# Verificar se a missão já existe no sistema global
	for mission in missions:
		if mission.title == new_mission.title:
			return false

# Verificar se o jogador já completou a missão
	for mission in PlayerManager.player.missions_complete:
		if mission.title == new_mission.title:
			return false

# Adiciona a missão ao sistema
	add_mission(new_mission, npc_id)
	return true
