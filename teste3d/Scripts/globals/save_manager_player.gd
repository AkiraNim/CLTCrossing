extends Node

var json = JSON.new()
var path = "user://player_data.json"

var data = {}

func write_save(content):
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(json.stringify(content))
	file.close()
	file = null

func load_save():
	var file = FileAccess.open(path,FileAccess.READ)
	var content = json.parse_string(file.get_as_text())
	return content

func create_new_save_file():
	var file = FileAccess.open("res://Scripts/default_save.json", FileAccess.READ)
	var content = json.parse_string(file.get_as_text())
	data = content
	write_save(content)

func _ready():
	create_new_save_file()
