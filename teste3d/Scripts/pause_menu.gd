extends CanvasLayer

@onready var resume_button: Button = $ColorRect2/menuGameOver/resume_button
@onready var quit_button: Button = $ColorRect2/menuGameOver/quit_button


func _on_resume_button_pressed() -> void:
	get_tree().paused = false


func _on_quit_button_pressed() -> void:
	get_tree().quit()
