extends Control

var progress = []
var scene_name = "res://scenes/world.tscn"
@export var scene_name_string:String 
var scene_load_status = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ResourceLoader.load_threaded_request(scene_name)
func _process(delta: float) -> void:
	scene_load_status = ResourceLoader.load_threaded_get_status(scene_name, progress)
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var new_scene = ResourceLoader.load_threaded_get(scene_name)
		get_tree().change_scene_to_packed(new_scene)
