extends HBoxContainer


@onready var coin_label: Label = $coinLabel

func update_coin(amount: int):
	coin_label.text = "%d" % amount
