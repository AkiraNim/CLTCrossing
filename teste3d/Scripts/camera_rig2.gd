extends Node3D
@onready var camera_player: Camera3D = $"../Player/Camera3D"

@onready var background_viewport: SubViewport = $base_camera/background_viewport_container/background_viewport
@onready var foreground_viewport: SubViewport = $base_camera/foreground_viewport_container/foreground_viewport

@onready var background_viewport_container: SubViewportContainer = $base_camera/background_viewport_container
@onready var foreground_viewport_container: SubViewportContainer = $base_camera/foreground_viewport_container

@onready var background_camera: Camera3D = $base_camera/background_viewport_container/background_viewport/background_camera
@onready var foreground_camera: Camera3D = $base_camera/foreground_viewport_container/foreground_viewport/foreground_camera

# Called when the node enters the scene tree for the first time.
func _ready():
		resize();

func resize():
	background_viewport.size = DisplayServer.window_get_size()
	foreground_viewport.size = DisplayServer.window_get_size()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	background_camera.global_transform = GameManager.player.camera_point.global_transform
	foreground_camera.global_transform = GameManager.player.camera_point.global_transform
	
func hide_camera():
	background_viewport_container.hide()
	foreground_viewport_container.hide()
	camera_player.show()

func show_camera():
	background_viewport_container.show()
	foreground_viewport_container.show()
	camera_player.hide()
