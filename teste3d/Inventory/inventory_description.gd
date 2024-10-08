extends CanvasLayer


@onready var inventory_description: CanvasLayer = $"."

func _ready() -> void:
	pass # Replace with function body.



func _process(delta: float) -> void:
	if inventory_description.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 


func _on_exit_button_pressed() -> void:
	inventory_description.hide()
