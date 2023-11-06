extends Node

var main
var player


func _unhandled_input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()
	if event.is_action_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			
