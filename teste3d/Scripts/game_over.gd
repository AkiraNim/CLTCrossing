extends CanvasLayer

@onready var retry_button: Button = $ColorRect/menuGameOver/retryButton



func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
