extends CharacterBody3D

@export var speed: float = 2.0

@onready var anim_sprite: AnimatedSprite3D = $AnimatedSprite3D




func _physics_process(delta):
	var input_dir = Vector3.ZERO

	# Coleta inputs
	if Input.is_action_pressed("move_forward"):
		input_dir.z -= 1
	if Input.is_action_pressed("move_backward"):
		input_dir.z += 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1

	# Normaliza direção (para não andar mais rápido na diagonal)
	if input_dir.length() > 0:
		input_dir = input_dir.normalized()
		velocity = input_dir * speed
	else:
		velocity = Vector3.ZERO

	# Move o personagem (sem gravidade)
	move_and_slide()

	# Atualiza animação
	_update_animation(input_dir)

func _update_animation(dir: Vector3) -> void:
	

	# Diagonais
	if dir.x > 0 and dir.z < 0:
		anim_sprite.play("walking_u_right") # diagonal up-right
	elif dir.x < 0 and dir.z < 0:
		anim_sprite.play("walking_u_left") # diagonal up-left
	elif dir.x > 0 and dir.z > 0:
		anim_sprite.play("walking_d_right") # diagonal down-right
	elif dir.x < 0 and dir.z > 0:
		anim_sprite.play("walking_d_left") # diagonal down-left
	# Horizontais / verticais
	elif dir.x > 0:
		anim_sprite.play("walking_right")
	elif dir.x < 0:
		anim_sprite.play("walking_left")
	elif dir.z < 0:
		anim_sprite.play("walking_up")
	elif dir.z > 0:
		anim_sprite.play("walking_down")
