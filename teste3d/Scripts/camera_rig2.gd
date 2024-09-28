extends Node3D

@onready var background_camera: Camera3D = $background_camera

func _process(delta):
	background_camera.global_transform = GameManager.player.camera_point.global_transform
