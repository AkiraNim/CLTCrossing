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
@onready var interact_label: Label = $InteractRay/InteractLabel
@onready var inventory_interface: Control = $"../Ui/InventoryInterface"

func _ready():
	PlayerManager.player = self
	GameManager.set_player(self)
