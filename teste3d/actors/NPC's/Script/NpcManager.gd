extends Node

var npc = npc_name

@export var npc_name: String

func get_global_position() -> Vector3:
	return npc.global_position
