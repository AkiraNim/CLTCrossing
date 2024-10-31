extends StaticBody3D

# Sinais para comunicação
signal dialog

# Variáveis exportadas
@export var pickup_scene: PackedScene  # Cena que representa o item dropado
@export var emotion: int
@export var npc_name: String
@export var inventory_data: InventoryData
@onready var npc: StaticBody3D = $"."


# Variáveis de controle
var rng = RandomNumberGenerator.new()
var mission_found = false
var mission_completed: bool = false

# Constantes para movimento e emoções
const RUN_SPEED = 5.0
const WALK_SPEED = 2.0
const JUMP_VELOCITY = 4.5
const EMOTION_CRYING = 0
const EMOTION_SIT = 1
const EMOTION_IDLE_SAD = 2
const EMOTION_IDLE = 3
const EMOTION_WALKING = 4
const EMOTION_RUNNING = 5

# Referências a nós prontos
@onready var animation_player: AnimationPlayer = $BusinessMan/AnimationPlayer
@onready var path_follow_3d: PathFollow3D = $".."

# Inicialização do NPC
func _ready() -> void:
	NpcManager.npc_name = npc_name
	NpcManager.npc = self
	if NpcManager.npc_name == "Bombeiro1":
		create_new_mission()


	# Atualiza a animação baseada na emoção inicial
	update_emotion_animation()

func _physics_process(delta: float) -> void:
	play_animation_based_on_emotion(delta)
	
	

# Atualiza a animação baseada na emoção
func update_emotion_animation() -> void:
	play_animation_based_on_emotion(0)

# Controla a animação com base na emoção
func play_animation_based_on_emotion(delta: float) -> void:
	match emotion:
		EMOTION_CRYING:
			animation_player.play("CryingIdle")
		EMOTION_SIT:
			animation_player.play("SitIdle")
		EMOTION_IDLE_SAD:
			animation_player.play("IdleSad")
		EMOTION_IDLE:
			animation_player.play("Idle")
		EMOTION_WALKING:
			animation_player.play("Walk")
			path_follow_3d.progress += WALK_SPEED * delta
		EMOTION_RUNNING:
			animation_player.play("Run")
			path_follow_3d.progress += RUN_SPEED * delta

# Função chamada quando o jogador interage com o NPC
func player_interact() -> void:
	dialog.emit(self)
	# Obtém missões baseadas na emoção do NPC
	var available_missions = MissionManager.get_available_missions(npc_name)

	if available_missions.size() > 0:
		for mission in available_missions:
			print("Missão disponível: ", mission.title)
	else:
		print("Nenhuma missão disponível.")
		
	if NpcManager.npc_name == "Bombeiro1":
		if PlayerManager.player.get_player_inventory_slot_data_quantity_by_name("Apple")>=2:
			for mission in MissionManager.missions:
				if mission.title == "Encontrar 2 maçãs":
					drop_npc_slot_data_by_name("Red Book")
					mission.complete_mission()
					mission_completed = true
					break

# Função que checa os itens do jogador

# Função que checa os itens do NPC
func check_npc_items() -> void:
	for i in range(NpcManager.npc.equip_inventory_data.slot_datas.size()):
		var slot_data = NpcManager.npc.inventory_data.slot_datas[i]
		if slot_data:
			var item_name = NpcManager.npc.inventory_data.get_slot_data_name(i, "")

# Solta todos os dados de slot do NPC
func drop_all_npc_slot_data() -> void:
	var a = 1.0
	for i in range(NpcManager.npc.inventory_data.slot_datas.size()):
		
		var slot_name = NpcManager.npc.inventory_data.get_slot_data_name(i)
		
		if slot_name:  # Checa o item específico para droppar
			drop_item_from_npc(i, a)
			a+=0.4

# Solta um item específico do NPC
func drop_npc_slot_data_by_name(name: String) -> void:
	for i in range(NpcManager.npc.inventory_data.slot_datas.size()):
		var slot_name = NpcManager.npc.inventory_data.get_slot_data_name(i)
		
		if slot_name == name:  # Checa o item específico para droppar
			drop_item_from_npc(i, 1)
			break

# Lógica para droppar um item do NPC
func drop_item_from_npc(index: int, i: float) -> void:
	var grabbed_slot_data: SlotData = NpcManager.npc.inventory_data.slot_datas[index]
	print("Item ", NpcManager.npc.inventory_data.get_slot_data_name(index), " foi droppado pelo NPC!")
	
	# Remove o item do inventário do NPC
	NpcManager.npc.inventory_data.slot_datas[index] = null
	NpcManager.npc.inventory_data.inventory_updated.emit(NpcManager.npc.inventory_data)
	
	# Instancia o Pickup para o item dropado
	if pickup_scene:
		var pickup_instance = pickup_scene.instantiate()
		pickup_instance.slot_data = grabbed_slot_data
		
		# Define a posição do item no mundo (perto do NPC)
		var direction = -NpcManager.npc.global_transform.basis.z * -i
		pickup_instance.global_transform.origin = NpcManager.npc.global_position + direction
		
		# Adiciona o Pickup à cena atual
		get_tree().current_scene.add_child(pickup_instance)

# Função que retorna o índice do item no inventário do NPC baseado no nome
func get_npc_equiped_slot_data_index_by_name(name: String) -> int:
	for i in range(NpcManager.npc.inventory_data.slot_datas.size()):
		if NpcManager.npc.inventory_data.get_slot_data_name(i) == name:
			return i
	return -1

# Função que retorna o índice do item no inventário do jogador baseado no nome

func create_new_mission() -> void:
	var new_mission = ResourceLoader.load("res://Mission/mission.gd").new()  # Carrega o script da missão
	new_mission.title = "Encontrar 2 maçãs"
	new_mission.description = "Ajude o NPC a encontrar 2 maçãs."
	new_mission.npc_name = npc_name # Emoção do NPC necessária para ativar a missão (Idle, por exemplo)
	new_mission.reward = "50 moedas de ouro"
	
	# Adiciona a missão ao sistema
	MissionManager.add_mission(new_mission)
	print("Missão criada: ", new_mission.title)
