extends CharacterBody3D

const SPEED = 200.0
const JUMP_VELOCITY = 10.0
@onready var  animator = get_node("sophia/AnimationPlayer") as AnimationPlayer

@export var view : Node3D
var gravity = 0
var movement_velocity : Vector3
var rotation_direction : float
var knockbacked := false

@onready var coins_container: HBoxContainer = $HUD/coinsContainer
@onready var life_container: HBoxContainer = $HUD2/lifeContainer
var life := 3
var coins := 0

var is_dead := false

func _physics_process(delta):
	if !knockbacked:
		handle_input(delta)
		if Vector2(velocity.z, velocity.x).length()>0:
			rotation_direction = Vector2(velocity.z, velocity.x).angle()
			
		rotation.y = lerp_angle(rotation.y, rotation_direction, delta * 10)
	jump ()
	handle_animations()
	
	var applied_velocity : Vector3
	applied_velocity = velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity
	
	velocity = applied_velocity
	
	apply_gravity(delta)

	if not is_on_floor():
		velocity.y -= gravity * delta

	move_and_slide()

func handle_input(delta) :
	var input = Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward","move_backward")
	input = input.rotated(Vector3.UP, view.rotation.y).normalized()
	
	if !knockbacked:
		velocity = input * SPEED * delta

func handle_animations():
	if !is_dead:
		
		if is_on_floor():
			if abs(velocity.x) > 1 or abs(velocity.z) > 1:
				animator.play("Run", 0.3)
			else:
				animator.play("Idle", 0.3)
		else:
			animator.play("Jump", 0.3)
			
		if knockbacked:
			animator.play("Fall", 0.3)
		if !is_on_floor() and gravity > 2:
			animator.play("Fall", 0.3)
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


func knockback(impact_poing: Vector3, force:Vector3):
	force.y = abs(force.y)
	velocity = force.limit_length(15.0)
	
	

func _on_hurtbox_body_entered(body):
	
	if life > 1:
		lost_life()
	else:
		is_dead = true
	var body_collision = (body.global_position - global_position)
	var force = -body_collision
	force *= 10.0
	gravity = -5
	knockback(body_collision, force)
	knockbacked = true
	
	await get_tree().create_timer(0.3).timeout
	knockbacked = false
	
func collect_coins():
	coins +=1
	coins_container.update_coin(coins)
func lost_life():
	life-=1
	life_container.update_life(life)
	
	
