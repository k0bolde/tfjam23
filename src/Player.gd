extends CharacterBody3D

var speed := 1.0
var curr_form := "knight"
var forms := ["knight", "cow", "anteater", "messenger"]


func _ready():
	Globals.player = self


func _physics_process(delta):
	pass
	
	
func change_form(new_form:String):
	if forms.has(new_form):
		curr_form = new_form
		#TODO play tf cutscene
		#TODO change model
	
	
func _unhandled_input(event):
	if event.is_action_pressed("click"):
		if DisplayServer.mouse_get_mode() == DisplayServer.MOUSE_MODE_VISIBLE:
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
	#TODO mouse look
	#TODO character movement
	#TODO inventory open/close
	#TODO scroll to adjust cam length
	#TODO jump
