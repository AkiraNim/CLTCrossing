extends RayCast3D

@onready var prompt: Label = $Prompt

func _ready() -> void:
	add_exception(owner)
	
func _physiscs_process(_delta):
	prompt.text = ""
	if is_colliding():
		print("Legau")
		prompt.text = "Legau"
