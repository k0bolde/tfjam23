extends Node

var main
var player
#used to preverse level state between loads. Could save this in the future for save files
var level_state := {}


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func _unhandled_input(event):
	#if event.is_action_pressed("quit"):
		#get_tree().quit()
	if event.is_action_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			
	if event.is_action_pressed("pause"):
		if not player.pause_menu.visible:
			player.pause_menu.visible = true
			get_tree().paused = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			get_tree().paused = false
			player.pause_menu.visible = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
			
#TODO replace with lerp_angle()
#rotate a vector towards another with a clamp on radians. Used for turn speed control.
func rotateTowards(from:Vector3, to:Vector3, max_radians:float) -> Vector3:
		var angle_to := from.angle_to(to)
		if angle_to > 0.0 and not is_nan(angle_to):
			var ret = from.slerp(to, min(1.0, max_radians / angle_to))
			return ret
		else:
			return to
			
			
func get_tween(the_tween:Tween, node) -> Tween:
	if the_tween:
		the_tween.kill()
	return get_tree().create_tween().bind_node(node)
