extends Control

@onready var credits: CanvasLayer = $Credits
@onready var controls: CanvasLayer = $Controls

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _on_btn_jogar_pressed() -> void:
	Globals.next_scene = "res://scenes/mapa.tscn"
	get_tree().change_scene_to_packed(Globals.loading_screen)
	if Dialogic.current_timeline == null:
		Dialogic.start('intro')  # Diálogo específico

func _on_btn_sair_pressed() -> void:
	get_tree().quit()

func _on_btn_creditos_pressed() -> void:
	credits.show()


func _on_btn_controles_pressed() -> void:
	controls.show()
