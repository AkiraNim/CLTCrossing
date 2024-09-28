extends CharacterBody3D

@export var inventory_data: InventoryData
@export var equip_inventory_data: InventoryDataEquip

const SPEED = 3.0
const JUMP_VELOCITY = 10

var stack = false
var gravity = 0
var movement_velocity : Vector3
var rotation_direction : float
var walking = false
var health: int = 5

signal toggle_inventory()

@onready var animation_player: AnimationPlayer = $visuals/sophia/AnimationPlayer
@onready var visuals: Node3D = $visuals
@onready var camera_point = $camera_point
@onready var coins_container: HBoxContainer = $"../CameraRig/HUD/coinsContainer"
@onready var life_container: HBoxContainer = $"../CameraRig/HUD3/lifeContainer"
@onready var background: ColorRect = $RayCast3D/Background
@onready var prompt: Label = $InteractRay/Prompt
@onready var interact_ray: RayCast3D = $InteractRay
@onready var player: CharacterBody3D = $"."
@onready var pause_menu: CanvasLayer = $"../pause_menu"

func _ready():
	PlayerManager.player = self
	GameManager.set_player(self)
	animation_player.set_blend_time("Idle", "Run", 0.2)
	animation_player.set_blend_time("Run", "Idle", 0.2)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

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

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		velocity.y = direction.z * SPEED
		visuals.look_at(direction + position)
		if !walking:
			walking=true
			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if walking:
			walking=false
			
	pause_menu.pause_resume()
	handle_animations()
	
	var applied_velocity : Vector3
	applied_velocity = velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity
	
	velocity = applied_velocity
	
	apply_gravity(delta)
	
	if is_on_floor():
			stack = true
		
	if !is_on_floor():
		velocity.y -= gravity * delta
		if stack:
			gravity = -JUMP_VELOCITY+5
			stack= false
	move_and_slide()
	
	if interact_ray.is_colliding():
		var detected = interact_ray.get_collider()
		if detected is Interactable:
			prompt.show()
			prompt.text = detected.name
	else:
		prompt.hide()
		prompt.text = ""

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * .002)
		
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
	
	if Input.is_action_just_pressed("interact"):
		interact()
		
func interact() -> void:
	if interact_ray.is_colliding():
		interact_ray.get_collider().player_interact()
		
func get_drop_position() -> Vector3:
	var direction = -player.global_transform.basis.z 
	return player.global_position + direction


func heal(heal_value: int) -> void:
	health += heal_value

func handle_animations():
	if is_on_floor():
		if abs(velocity.x) > 1 or abs(velocity.z) > 1:
			animation_player.play("Run", 0.3)
		else:
			animation_player.play("Idle", 0.3)
	else:
		animation_player.play("Jump", 0.3)
		
	if !is_on_floor() and gravity > 2:
		animation_player.play("Fall", 0.3)
	
func apply_gravity(delta):
	if !is_on_floor():
		gravity += 25 * delta
		
func jump ():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		gravity = -JUMP_VELOCITY-5
		
	if gravity > 0 and is_on_floor():
		gravity = 0
	
	
