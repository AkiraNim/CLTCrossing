extends StaticBody3D

# Sinais para comunicação
signal dialog

# Variáveis exportadas
@export var emotion: int
@export var npc_name: String
@export var inventory_data: InventoryData


@onready var npc: StaticBody3D = $"."

# Variáveis de controle
var rng = RandomNumberGenerator.new()
var mission: Mission
var mission_found = false
var mission_completed: bool = false
var npcId: int
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
@onready var animation_player: AnimationPlayer = $Firefighter/AnimationPlayer
@onready var path_follow_3d: PathFollow3D = $".."

# Inicialização do NPC
func _ready() -> void:
	rng.randomize()
	if npc_name == "Bombeiro1":
		MissionManager.create_new_mission(npc_name, "Encontrar 2 maçãs", "Ajude o npc a encontrar maçãs", "50 moedas")
	# Atualiza a animação baseada na emoção inicial
	
	var npc: Npc = Npc.new()
	
	npc.emotion = emotion
	npc.inventory_data = inventory_data
	npc.npc_name = npc_name
	npcId = rng.randi_range(0,1000000)
	npc.npcId = npcId
	for npcs in NpcManager.npcs:
		if npcs.npcId == npcId:
			while npcs.npcId == npcId:
				npcId = rng.randi_range(0,10000)
				npc.npcId = npcId
	
	NpcManager.add_npc(npc)
	
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
	for npcs in NpcManager.npcs:
		if npcs.npcId == npcId:
			check_npc_items()
			drop_item_from_npc(npcId, 2)
			drop_npc_slot_data_by_name("Apple")
			drop_all_npc_slot_data()
			for missions in MissionManager.get_available_missions():
				print(missions.title)
				if npcs.npc_name == "Bombeiro1":
					if missions.title == "Encontrar 2 maçãs":
						missions.complete_mission(missions)
# Função que checa os itens do NPC
func check_npc_items() -> void:
	for npcs in NpcManager.npcs:
		if npcs.npcId == npcId:
			for i in range(npcs.inventory_data.slot_datas.size()):
				var slot_data = npcs.inventory_data.slot_datas[i]
				if slot_data:
					var item_name = npcs.inventory_data.get_slot_data_name(i)

func drop_item_from_npc(npcId: int, index: int) -> void:
	var grabbed_slot_data: SlotData = null

	# Procura o NPC específico pelo npcId
	for npc in NpcManager.npcs:
		if npc.npcId == npcId:
			# Pega os dados do slot especificado e remove o item do inventário
			if index < npc.inventory_data.slot_datas.size():
				grabbed_slot_data = npc.inventory_data.slot_datas[index]
				if grabbed_slot_data:
					print("Item ", npc.inventory_data.get_slot_data_name(index), " foi droppado pelo NPC!")
					npc.inventory_data.slot_datas[index] = null
					npc.inventory_data.inventory_updated.emit(npc.inventory_data)
	
	if grabbed_slot_data:
		PlayerManager.player.inventory_data.pick_up_slot_data(grabbed_slot_data)

func drop_all_npc_slot_data() -> void:
	for npc in NpcManager.npcs:
		if npc.npcId == npcId:
			for i in range(npc.inventory_data.slot_datas.size()):
				if npc.inventory_data.slot_datas[i]:
					drop_item_from_npc(npc.npcId, i)

# Solta um item específico do NPC
func drop_npc_slot_data_by_name(name: String) -> void:
	for npc in NpcManager.npcs:
		if npc.npcId == npcId:
			for i in range(npc.inventory_data.slot_datas.size()):
				if npc.inventory_data.get_slot_data_name(i) == name:
					drop_item_from_npc(npc.npcId, i)
	
func get_npc_equiped_slot_data_index_by_name(name: String) -> int:
	for npc in NpcManager.npcs:
		if npc.npcId == npcId:
			for i in range(npc.inventory_data.slot_datas.size()):
				if npc.inventory_data.get_slot_data_name(i) == name:
					return i
	return -1
