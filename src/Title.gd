extends Node3D

@onready var cam : Camera3D = $Camera3D
var cam_tween_rot_x : Tween
var cam_tween_rot_y : Tween
var cam_tween_pos_x : Tween
var cam_tween_pos_y : Tween


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	cam_tween_rot_x = create_tween()
	cam_tween_rot_x.set_loops().set_trans(Tween.TRANS_SINE)
	cam_tween_rot_x.tween_property(cam, "rotation:x", deg_to_rad(-16), 10.0)
	cam_tween_rot_x.tween_property(cam, "rotation:x", deg_to_rad(-30), 10.0)
	cam_tween_rot_y = create_tween()
	cam_tween_rot_y.set_loops().set_trans(Tween.TRANS_SINE)
	cam_tween_rot_y.tween_property(cam, "rotation:y", deg_to_rad(-24), 8.0)
	cam_tween_rot_y.tween_property(cam, "rotation:y", deg_to_rad(12), 8.0)
	cam_tween_pos_x = create_tween()
	cam_tween_pos_x.set_loops().set_trans(Tween.TRANS_SINE)
	cam_tween_pos_x.tween_property(cam, "position:x", -0.2, 6.0)
	cam_tween_pos_x.tween_property(cam, "position:x", -0.5, 6.0)
	cam_tween_pos_y = create_tween()
	cam_tween_pos_y.set_loops().set_trans(Tween.TRANS_SINE)
	cam_tween_pos_y.tween_property(cam, "position:y", 1.4, 12.0)
	cam_tween_pos_y.tween_property(cam, "position:y", 1.0, 12.0)


func _on_button_pressed():
	get_tree().quit()


func _on_start_button_pressed():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
	get_tree().change_scene_to_file("res://src/Main.tscn")


func _on_credits_button_pressed():
	var c = preload("res://src/Credits.tscn").instantiate()
	add_child(c)


func _on_options_button_pressed():
	#TODO open options
	pass # Replace with function body.
