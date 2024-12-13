extends RigidBody3D

@export var slot_data: SlotData
@onready var sprite_3d: Sprite3D = $Sprite3D

# Variáveis para controlar o movimento de subida e descida
@export var min_height: float = -0.3  # Posição mínima no eixo Y (abaixo)
@export var max_height: float = 0.3  # Posição máxima no eixo Y (acima)
@export var speed: float = 2.0  # Velocidade do movimento

# Tempo acumulado
var time: float = 0.0

func _ready() -> void:
	sprite_3d.texture = slot_data.item_data.texture

func _physics_process(delta: float) -> void:
# Atualizar o tempo
	time += delta * speed

# Calcular o deslocamento vertical baseado nos limites
	var height = lerp(min_height, max_height, (sin(time) + 1) / 2)

# Atualizar a posição do Sprite3D
	var new_position = sprite_3d.global_transform.origin
	new_position.y = global_transform.origin.y + height
	sprite_3d.global_transform.origin = new_position

# Fazer o sprite girar no eixo Y
	sprite_3d.rotate_y(delta)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		var item_data = slot_data.item_data
# Usa a função para verificar se o jogador já tem o item
		if body.inventory_data.pick_up_slot_data(slot_data):  # Adiciona o item ao inventário
			queue_free()
