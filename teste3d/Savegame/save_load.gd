extends Node


func save_game():
	var saved_game:SavedGame = SavedGame.new()
	
	saved_game.player_position = PlayerManager.get_global_position()
	saved_game.inventory = PlayerManager.player.inventory_data
	saved_game.equip_inventory = PlayerManager.player.equip_inventory_data
	saved_game.money = PlayerManager.player.money
	saved_game.missions_complete = PlayerManager.player.missions_complete
	ResourceSaver.save(saved_game, "user://savegame.tres")
	
func load_game():
	if FileAccess.file_exists("user://savegame.tres"):
		var saved_game: SavedGame = load("user://savegame.tres") as SavedGame
		if saved_game:
			PlayerManager.player.global_position = saved_game.player_position
			PlayerManager.player.money = saved_game.money
			for i in range(PlayerManager.player.inventory_data.slot_datas.size()):
				PlayerManager.player.inventory_data.slot_datas[i] = saved_game.inventory.slot_datas[i]
			for i in range(PlayerManager.player.equip_inventory_data.slot_datas.size()):
				PlayerManager.player.equip_inventory_data.slot_datas[i] = saved_game.equip_inventory.slot_datas[i]
				PlayerManager.player.inventory_data.inventory_updated.emit(PlayerManager.player.inventory_data)
				PlayerManager.player.equip_inventory_data.inventory_updated.emit(PlayerManager.player.equip_inventory_data)
				PlayerManager.player.missions_complete = saved_game.missions_complete
