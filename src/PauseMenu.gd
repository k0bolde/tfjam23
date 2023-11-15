extends Control


func _on_quit_button_pressed():
	get_tree().quit()


func _on_main_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://src/Title.tscn")


func _on_respawn_button_pressed():
	Globals.main.change_level(Globals.main.curr_level_idx)
	_on_resume_button_pressed()


func _on_options_button_pressed():
	var options = preload("res://src/Options.tscn").instantiate()
	add_child(options)


func _on_resume_button_pressed():
	get_tree().paused = false
	Globals.player.pause_menu.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
