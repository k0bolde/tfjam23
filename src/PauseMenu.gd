extends Control


func _on_quit_button_pressed():
	get_tree().quit()


func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://src/Title.tscn")


func _on_respawn_button_pressed():
	Globals.main.change_level(Globals.main.curr_level_idx)


func _on_options_button_pressed():
	#TODO open options menu
	pass # Replace with function body.


func _on_resume_button_pressed():
	#TODO unpause
	pass # Replace with function body.
