extends HBoxContainer


@onready var coin_label: Label = $coinLabel
@onready var life_label: Label = $lifeLabel

func update_coin(amount: int):
	life_label.text = "%d" % amount
