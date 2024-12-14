extends Control

@onready var pop_up: Control = $"."
@onready var label_pop_up: Label = $LabelPopUp
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var timer = Timer.new()

func pop_up_invisible()->void:
	animation_player.play("pop_up_invisible")
func open_popUp()->void:
	animation_player.play("popUp")
func close_popUp()->void:
	animation_player.play_backwards("popUp")

func set_popup_text(text: String, duration: float):
	label_pop_up.text = text
	pop_up.show()
	pop_up.open_popUp()
	timer.wait_time = duration
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.connect("timeout", Callable(self, "_timer_pop_up"))

func _timer_pop_up():
	pop_up.close_popUp()
