extends Node3D

class_name Npc

var npc_name: String
var inventory_data: InventoryData
var emotion: int
var npcId: int

func get_npc_emotion() -> int:
	return emotion  # Supondo que o NPC tenha uma propriedade "emotion"

func get_npc_global_position() -> Vector3:
	return global_transform.origin
