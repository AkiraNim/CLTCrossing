extends CanvasLayer

@onready var credits: CanvasLayer = $"."

func _on_exit_button_pressed() -> void:
	credits.hide()
