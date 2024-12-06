extends Node3D

const WALK_SPEED = 3.0

@onready var path_follow_3d: PathFollow3D = $".."

func _process(delta: float) -> void:
	path_follow_3d.progress += WALK_SPEED * delta
