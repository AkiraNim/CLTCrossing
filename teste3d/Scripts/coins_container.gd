extends HBoxContainer


@onready var life_label: Label = $"../../HUD2/lifeContainer/lifeLabel"

func update_life(amount: int):
	life_label.text = "%d" % amount
