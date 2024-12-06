extends CollisionShape3D

@onready var camera_rig: Node3D = $"../../CameraRig"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	camera_rig.hide_camera()


func _on_area_3d_body_exited(body: Node3D) -> void:
	camera_rig.show_camera()
