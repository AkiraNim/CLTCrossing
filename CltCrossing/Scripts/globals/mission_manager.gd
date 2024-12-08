extends Node

# Lista de todas as missões disponíveis no jogo
var missions: Array = []

# Adiciona uma nova missão ao sistema
func add_mission(mission: Mission, npc_name: String) -> void:
# Confirma que o nome do NPC é válido (se necessário)
	if mission.npc_name == npc_name:
		missions.append(mission)
		print("Missão adicionada com sucesso: ", mission.title)
	else:
		print("Erro: NPC não corresponde para a missão:", mission.title)

# Retorna uma lista de missões disponíveis com base no estado de conclusão
func get_available_missions() -> Array:
	var available_missions = []
	for mission in missions:
		if !mission.is_completed:
			available_missions.append(mission)
	return available_missions

# Cria uma nova missão e a adiciona ao sistema
func create_new_mission(npc_name: String, mission_title: String, mission_description: String, mission_reward: String) -> bool:
	print("Tentando criar nova missão:", mission_title)

# Cria a nova missão usando o recurso
	var new_mission = ResourceLoader.load("res://Mission/mission.gd").new()
	new_mission.title = mission_title
	new_mission.description = mission_description
	new_mission.npc_name = npc_name
	new_mission.reward = mission_reward

# Verificar se a missão já existe no sistema global
	for mission in missions:
		if mission.title == new_mission.title:
			print("Missão já existe no sistema:", mission.title)
			return false

# Verificar se o jogador já completou a missão
	for mission in PlayerManager.player.missions_complete:
		if mission.title == new_mission.title:
			print("Jogador já completou esta missão:", mission.title)
			return false

# Adiciona a missão ao sistema
	add_mission(new_mission, npc_name)
	print("Missão criada e adicionada com sucesso:", mission_title)
	return true
