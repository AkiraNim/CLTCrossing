extends StaticBody3D


func player_interact():
	Globals.next_scene = "res://scenes/banco.tscn"
	get_tree().change_scene_to_packed(Globals.loading_screen)
	SaveLoad.save_game()
