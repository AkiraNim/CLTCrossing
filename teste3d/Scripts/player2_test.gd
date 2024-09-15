extends CharacterBody3D


const SPEED = 3.0
const JUMP_VELOCITY = 10

var gravity = 0
var movement_velocity : Vector3
var rotation_direction : float
var knockbacked := false

var life := 3
var coins := 0

var is_dead := false 

@onready var animation_player: AnimationPlayer = $visuals/sophia/AnimationPlayer

@onready var visuals: Node3D = $visuals

@onready var camera_point = $camera_point

var walking = false

func _ready():
	GameManager.set_player(self)
	animation_player.set_blend_time("Idle", "Run", 0.2)
	animation_player.set_blend_time("Run", "Idle", 0.2)

func _physics_process(delta):
	
		
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		visuals.look_at(direction + position)
		
		if !walking:
			walking=true
			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
		if walking:
			walking=false
			
	jump()
	
	handle_animations()
	
	move_and_slide()
	
	var applied_velocity : Vector3
	applied_velocity = velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity
	
	velocity = applied_velocity
	
	apply_gravity(delta)

func handle_animations():
	if !is_dead:
		
		if is_on_floor():
			if abs(velocity.x) > 1 or abs(velocity.z) > 1:
				animation_player.play("Run", 0.3)
			else:
				animation_player.play("Idle", 0.3)
		else:
			animation_player.play("Jump", 0.3)
			
		if knockbacked:
			animation_player.play("Fall", 0.3)
		if !is_on_floor() and gravity > 2:
			animation_player.play("Fall", 0.3)
	else:
		get_parent().get_node("gameOver").visible = true
		get_tree().paused = true
	
func apply_gravity(delta):
	if !is_on_floor():
		gravity += 25 * delta
		
func jump ():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		gravity = -JUMP_VELOCITY
		
	if gravity > 0 and is_on_floor():
		gravity = 0
