extends CharacterBody3D

@export var inventory_data: InventoryData
@export var equip_inventory_data: InventoryDataEquip

const SPEED = 3.0
const JUMP_VELOCITY = 10

var money: float = 100.25
var stack = false
var gravity = 0
var movement_velocity : Vector3
var rotation_direction : float
var walking = false
var health: int = 5
var missions_complete:= []

signal toggle_inventory()

@onready var animation_player: AnimationPlayer = $visuals/sophia/AnimationPlayer
@onready var visuals: Node3D = $visuals
@onready var camera_point = $camera_point
@onready var coins_container: HBoxContainer = $"../CameraRig/HUD/coinsContainer"
@onready var life_container: HBoxContainer = $"../CameraRig/HUD3/lifeContainer"
@onready var background: ColorRect = $RayCast3D/Background
@onready var interact_ray: RayCast3D = $InteractRay
@onready var pause_menu: CenterContainer = $"../pause_menu"
@onready var inventory_interface: Control = $"../Ui/InventoryInterface"
@onready var interact_label: Label = $"../Ui/InteractNode/InteractLabel"
@onready var prompt: Label = $"../Ui/InteractNode/Prompt"
@onready var interact_node: Node2D = $"../Ui/InteractNode"

var current_money: int = 0  # Valor atual de dinheiro
var previous_money: int = 0  # Valor anterior de dinheiro

func _ready():
	PlayerManager.player = self

	animation_player.set_blend_time("Idle", "Run", 0.2)
	animation_player.set_blend_time("Run", "Idle", 0.2)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	current_money = money
	previous_money = current_money

func _physics_process(delta):
	if current_money > previous_money:
		print("Dinheiro aumentou!")
	elif current_money < previous_money:
		print("Dinheiro diminuiu!")

# Atualize o valor anterior para o próximo quadro
	previous_money = current_money
	
	
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
	
	if interact_ray.is_colliding() and !inventory_interface.visible:
		var detected = interact_ray.get_collider()
		if detected.is_in_group("Interactable"):
			prompt.text = detected.name
			interact_node.show()
	else:
		interact_node.hide()
		prompt.text = ""
		

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * .002)
		
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
		
	
	if Input.is_action_just_pressed("interact"):
		interact()
		
func interact() -> void:
	var detected = interact_ray.get_collider()
	if interact_ray.is_colliding() and detected.is_in_group("Interactable"):
		detected.player_interact()
		
func get_drop_position() -> Vector3:
	var direction = -PlayerManager.player.global_transform.basis.z*2 
	return PlayerManager.player.global_position + direction

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
		
func check_player_items_by_name(name: String) -> String:
	if get_player_equiped_slot_data_index_by_name(name)!=-1\
	or get_player_inventory_slot_data_index_by_name(name)!=-1:
		return name
	return ""
	
func get_player_equiped_slot_data_index_by_name(name: String) -> int:
	for i in range(PlayerManager.player.equip_inventory_data.slot_datas.size()):
		if PlayerManager.player.equip_inventory_data.get_slot_data_name(i) == name:
			return i
	return -1
	
func get_player_inventory_slot_data_index_by_name(name: String) -> int:
	for i in range(PlayerManager.player.inventory_data.slot_datas.size()):
		if PlayerManager.player.inventory_data.get_slot_data_name(i) == name:
			return i
	return -1
	
func get_player_equiped_slot_data_quantity_by_name(name: String)-> int:
	var index = get_player_equiped_slot_data_index_by_name(name)
	if PlayerManager.player.equip_inventory_data.get_slot_data_quantity(index)!=-1:
		return PlayerManager.player.equip_inventory_data.get_slot_data_quantity(index)
	return -1
	
func get_player_inventory_slot_data_quantity_by_name(name: String)-> int:
	var index = get_player_inventory_slot_data_index_by_name(name)
	if PlayerManager.player.inventory_data.get_slot_data_quantity(index)!=-1:
		return PlayerManager.player.inventory_data.get_slot_data_quantity(index)
	return -1

func player_have_this_item(item_data: ItemData)-> bool:
	for i in range(PlayerManager.player.equip_inventory_data.slot_datas.size()):
		if PlayerManager.player.equip_inventory_data.get_slot_data_name(i) == item_data.name\
			and item_data.unique:
			return true
	for i in range(PlayerManager.player.inventory_data.slot_datas.size()):
		if PlayerManager.player.inventory_data.get_slot_data_name(i) == item_data.name\
		and item_data.unique:
			return true
	return false

func add_money(external_money: float)-> void:
	money+=external_money
