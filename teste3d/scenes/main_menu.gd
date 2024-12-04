extends Node2D

@onready var credits: CanvasLayer = $Credits

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE




func _on_btn_jogar_pressed() -> void:
	print("ok")


func _on_btn_interacao_pressed() -> void:
	pass


func _on_btn_sair_pressed() -> void:
	get_tree().quit()


func _on_btn_creditos_pressed() -> void:
	credits.show()
