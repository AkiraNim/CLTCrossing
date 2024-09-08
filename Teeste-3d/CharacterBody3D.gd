extends CharacterBody3D


const SPEED = 200.0
const JUMP_VELOCITY = 10.0

@onready var animator = get_node("sophia/AnimationPlayer") as AnimationPlayer
@export var view: Node3D
var gravity = 0
var movement_velocity : Vector3
var rotation_direction : float



func _physics_process(delta):
	handle_input(delta)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	
	move_and_slide()

func handle_input(delta):
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_backward")
	
	input = input.rotated(Vector3.UP, view.roation.y).normalized()
	
	velocity = input * SPEED * delta

func handle_animations():
	pass
	
func apply_gravity(delta):
	pass
	
func jump(delta):
	pass
