extends CanvasLayer

@onready var canvas_layer: CanvasLayer = $"."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_button_pressed() -> void:
	canvas_layer.hide()
