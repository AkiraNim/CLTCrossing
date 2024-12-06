extends CanvasLayer


@onready var inventory_description: CanvasLayer = $"."

func _ready() -> void:
	pass # Replace with function body.

func _on_exit_button_pressed() -> void:
	inventory_description.hide()
