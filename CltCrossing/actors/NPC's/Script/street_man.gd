extends CharacterBody3D

# Referências a nós prontos
@onready var animation_player: AnimationPlayer = $StreetMan/AnimationPlayer
@export var have_path: bool
@export var RUN_SPEED = 2.0
@onready var path_follow_3d: PathFollow3D = $".."

func _physics_process(delta: float) -> void:
	animation_player.play("Run")
	path_follow_3d.progress += RUN_SPEED * delta
# Atualiza a animação baseada na emoção
