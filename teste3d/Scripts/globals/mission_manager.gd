# mission_manager.gd
extends Node

# Lista de todas as missões disponíveis no jogo
var missions: Array = []

func _physics_process(delta: float) -> void:
	pass
# Adiciona uma nova missão ao sistema
func add_mission(mission: Mission, npc_name: String) -> void:
	mission.npc_name == npc_name
	missions.append(mission)
	print("Nova missão adicionada: ", mission.title)

# Retorna uma lista de missões disponíveis com base na emoção
func get_available_missions() -> Array:
	var available_missions = []
	for mission in missions:
		if !mission.is_completed:
			available_missions.append(mission)
	return available_missions

func create_new_mission(npc_name: String, mission_title: String, mission_description: String, mission_reward: String) -> bool:
	var new_mission = ResourceLoader.load("res://Mission/mission.gd").new()  # Carrega o script da missão
	
	for missions in MissionManager.get_available_missions():
		new_mission.title = mission_title
		new_mission.description = mission_description
		new_mission.npc_name = npc_name # Emoção do NPC necessária para ativar a missão (Idle, por exemplo)
		new_mission.reward = mission_reward
		if missions.title == new_mission.title:
			return false
		else:
			for mission in PlayerManager.player.missions_complete:
				if mission.title == mission_title:
					return false
	# Adiciona a missão ao sistema
	MissionManager.add_mission(new_mission, npc_name)
	return true
