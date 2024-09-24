extends CanvasLayer

@onready var resume_button: Button = $ColorRect2/menuGameOver/resume_button
@onready var quit_button: Button = $ColorRect2/menuGameOver/quit_button

func pause_resume():
	if Input.is_action_just_pressed("pause_resume") and !get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pause()
	elif Input.is_action_just_pressed("pause_resume") and get_tree().paused:
		resume()
	
func _on_resume_button_pressed() -> void:
	resume()
	

func _on_quit_button_pressed() -> void:
	get_tree().quit()
	get_parent().get_node("pause_menu").visible = false
	
	
func pause():
	get_tree().paused=true;
	get_parent().get_node("pause_menu").visible = true
	
func resume():
	get_tree().paused=false;
	get_parent().get_node("pause_menu").visible = false
