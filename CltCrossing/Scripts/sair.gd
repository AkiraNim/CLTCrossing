extends StaticBody3D


func player_interact():
	Globals.next_scene = "res://scenes/mapa_principal.tscn"
	get_tree().change_scene_to_packed(Globals.loading_screen)
	SaveLoad.save_inventory()
