# mission.gd
extends Resource

class_name Mission

@export var title: String
@export var description: String
@export var npc_name: String  # Emoção necessária do NPC para a missão
@export var is_completed: bool = false  # Estado da missão
@export var reward: String  # Pode ser um item, experiência, etc.
@export var npc_id: int
# Método para verificar se a missão está concluída


func check_completion() -> bool:
	if is_completed:
		return true
	return false

# Método para completar a missão
func complete_mission(mission: Mission) -> String:
	if !mission.is_completed:
		PlayerManager.player.missions_complete.append(mission)
		mission.is_completed = true
	return "Missão %s completada com sucesso." % [mission.title]
