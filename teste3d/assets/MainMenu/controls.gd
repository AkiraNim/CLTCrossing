extends CanvasLayer

@onready var controls: CanvasLayer = $"."


func _on_exit_button_pressed() -> void:
	controls.hide()
