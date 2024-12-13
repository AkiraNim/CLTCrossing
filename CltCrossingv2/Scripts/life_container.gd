extends HBoxContainer


@onready var life_label: Label = $lifeLabel

func _ready():
	life_label.text = str(3)
	
func update_life(health: int):
	life_label.text = "%d" % health
