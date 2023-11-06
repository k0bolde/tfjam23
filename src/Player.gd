extends CharacterBody3D

var speed := 1.0


func _ready():
	Globals.player = self


func _physics_process(delta):
	pass
	
	
func _unhandled_input(event):
	if event.is_action_pressed("click"):
		if DisplayServer.mouse_get_mode() == DisplayServer.MOUSE_MODE_VISIBLE:
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
