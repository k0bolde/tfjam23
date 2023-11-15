extends CanvasLayer

@onready var res_slider : HSlider = $Control/MarginContainer/CenterContainer/VBoxContainer/ResSlider
@onready var shadow_slider : HSlider = $Control/MarginContainer/CenterContainer/VBoxContainer/ShadowSlider
@onready var crt_button : CheckButton = $Control/MarginContainer/CenterContainer/VBoxContainer/CRTButton
@onready var aa_button : CheckButton = $Control/MarginContainer/CenterContainer/VBoxContainer/AAButton


func _ready():
	crt_button.button_pressed = Globals.player.shader.visible
	aa_button.button_pressed = get_viewport().screen_space_aa == Viewport.SCREEN_SPACE_AA_FXAA
	#TODO scaling is always read as 1.0? save as a var in globals?
	var scaling_val = get_viewport().scaling_3d_scale
	match scaling_val:
		0.1:
			res_slider.value = 0
		0.25:
			res_slider.value = 1
		0.5:
			res_slider.value = 2
		1.0:
			res_slider.value = 3
			



func _on_crt_button_toggled(button_pressed):
	Globals.player.shader.visible = button_pressed


func _on_aa_button_toggled(button_pressed):
	get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA if button_pressed else Viewport.SCREEN_SPACE_AA_DISABLED


func _on_res_slider_drag_ended(value_changed):
	if value_changed:
		var val : int = res_slider.value
		match val:
			0:
				get_viewport().scaling_3d_scale = 0.1
			1:
				get_viewport().scaling_3d_scale = 0.25
			2:
				get_viewport().scaling_3d_scale = 0.5
			3:
				get_viewport().scaling_3d_scale = 1.0


func _on_shadow_slider_drag_ended(value_changed):
	#adjust get_viewport().positional_shadow_atlas_size 
	# and RenderingServer.directional_shadow_atlas_set_size()
	# and RenderingServer.directional_soft_shadow_filter_set_quality()
	# and RenderingServer.positional_soft_shadow_filter_set_quality()
	if value_changed:
		match shadow_slider.value:
			0:
				pass
			1:
				pass
			2:
				pass
			3:
				pass


func _on_defaults_button_pressed():
	pass # Replace with function body.


func _on_close_button_pressed():
	queue_free()
