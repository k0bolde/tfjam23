extends Node

var main : Main
var player : Player


func _unhandled_input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()
	if event.is_action_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			
			
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
