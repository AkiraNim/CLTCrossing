extends StaticBody3D

@export var inventory_data: InventoryData

@onready var pop_up: Control = $"../../../Ui/PopUp"

var twice:bool = true
var timer = Timer

func player_interact():
	if twice == true:
		pop_up.set_popup_text("Dropando...", 5.0)
		var timer = Timer.new()
		timer.wait_time = 5.0
		timer.one_shot = true
		add_child(timer)
		timer.start()
		timer.connect("timeout", Callable(self, "_timer_pop_up"))
		twice = false

func drop_item():
	if inventory_data.slot_datas[0].quantity>inventory_data.slot_datas[1].quantity:
		inventory_data.slot_datas[0] = inventory_data.slot_datas[1]
	var grabbed_slot_data:SlotData
	grabbed_slot_data = inventory_data.slot_datas[0]
	if grabbed_slot_data:
		pop_up.set_popup_text("Item %s recebido.\n+%d" % [grabbed_slot_data.item_data.name, grabbed_slot_data.quantity], 2.0)
		PlayerManager.player.inventory_data.pick_up_slot_data(grabbed_slot_data)

func _timer_pop_up():
	twice = true
	drop_item()
