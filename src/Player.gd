extends CharacterBody3D
class_name Player

@onready var rotation_helper = $Gimbal/RotationHelper
@onready var gimbal = $Gimbal
@onready var gimbal_origin : Vector3 = gimbal.transform.origin
@onready var camera : Camera3D = $Gimbal/RotationHelper/SpringArm3D/InterpolatedCamera3D
@onready var springarm : SpringArm3D = $Gimbal/RotationHelper/SpringArm3D
@onready var dialog_node : Control = %Dialog
@onready var dialog_label : Label = %DialogLabel
@onready var talk_prompt : Control = %TalkPrompt
@onready var next_prompt : Control = %NextPrompt
@onready var prompt_label : Label = %PromptLabel
@onready var shader : TextureRect = %ShaderRect
@onready var crosshair : TextureRect = %Crosshair

var MOUSE_SENSITIVITY := 0.1
var TURN_SPEED := 0.05
var max_speed := 10.0
var ACCEL := 0.05
var DEACCEL := 0.1
var jump_speed := 12.0
var input_movement_vector : Vector2
var player_dir := Vector3()
var vdir := Vector3()
var last_vdir := Vector3()
var vel := Vector3()
var zoom_tween : Tween
var jump_requested := false
var target_spring_length := 2.0
var is_cutscene_playing := false

var curr_form := "knight"
var forms := {"knight": {}, "cow": {}, "bird": {}}
var is_tfing := false

var curr_interact_area
var dialog_callable : Callable
var curr_npc_name : String

func _ready():
	Globals.player = self
	forms["knight"]["model"] = get_node("Models/knight")
	forms["cow"]["model"] = get_node("Models/cow")
	forms["bird"]["model"] = get_node("Models/bird")
	
	forms["knight"]["col"] = get_node("KnightCollision")
	forms["cow"]["col"] = get_node("CowCollision2")
	forms["bird"]["col"] = get_node("KnightCollision")

	forms["knight"]["speed"] = 6.0
	forms["cow"]["speed"] = 20.0
	forms["bird"]["speed"] = 12.0
	
	forms["knight"]["turn_speed"] = 0.06
	forms["cow"]["turn_speed"] = 0.03
	forms["bird"]["turn_speed"] = 0.1
	
	forms["knight"]["jump_speed"] = 10.0
	forms["cow"]["jump_speed"] = 8.0
	forms["bird"]["jump_speed"] = 16.0
	
	forms["knight"]["accel"] = 0.05
	forms["cow"]["accel"] = 0.0025
	forms["bird"]["accel"] = 0.1

	change_form("knight")
	
	RenderingServer.viewport_set_scaling_3d_scale(get_viewport().get_viewport_rid(), 0.5)
	get_viewport().size_changed.connect(window_resize)
	window_resize()

func _physics_process(_delta):
	if is_cutscene_playing:
		return
	var cam_xform := camera.get_global_transform()
	var clamped_move_vec := input_movement_vector.normalized()
	var dir := Vector3()
	dir += -cam_xform.basis.z * clamped_move_vec.y
	dir += cam_xform.basis.x * clamped_move_vec.x
	dir.y = 0.0
	if is_on_floor():
		if jump_requested:
			jump_requested = false
			vel.y += jump_speed
			vel += get_platform_velocity()
		else:
			vel.y = 0.0
	else:
		vel.y -= 1.0
		
	var curr_vel := last_vdir
	curr_vel.y = 0.0
	curr_vel = curr_vel.normalized()
	#TODO condense input_movement_vector checks
	if input_movement_vector.length() > 0.0:
		player_dir = dir
	if player_dir.dot(curr_vel) < -0.90:
		player_dir.x += 0.1
	#TODO change to lerp_angle()?
	if input_movement_vector.length() > 0.0:
		vdir = Globals.rotateTowards(curr_vel, player_dir, TURN_SPEED)
		
	var hvel := vel
	hvel.y = 0
	var target := dir * max_speed
	var accel: float
	#dot product tells us if we're going faster than max speed or not
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL
	#cow moves in the dir they're facing
	if curr_form == "cow" and input_movement_vector.length() > 0.0:
		target = vdir.normalized() * max_speed
		if vdir.normalized().dot(hvel) > 0:
			accel = ACCEL
		else:
			accel = DEACCEL

	hvel = hvel.lerp(target, accel)
	vel.x = hvel.x
	vel.z = hvel.z		

	
	velocity = vel
	move_and_slide()
	
	last_vdir = vdir
	vel = velocity
	var look_vec = vdir + get_transform().origin
#	only change look_at if its not already looking at the thing. Uses the built in check look_at uses
	if (input_movement_vector.length() > 0.0 and Vector3.UP.cross(vdir) != Vector3.ZERO):
		look_at(look_vec)
#		lock to only y rotation, got extra z and x we don't need from the look_at
		var my_rot = get_rotation()
		my_rot.x = 0
		my_rot.z = 0
		set_rotation(my_rot)
	gimbal.global_position = global_position + Vector3(0, 1.5, 0)
	
	
func change_form(new_form:String):
	if forms.keys().has(new_form) and curr_form != new_form:
		var last_form := curr_form
		curr_form = new_form
		
		forms[last_form]["model"].visible = false
		forms[last_form]["col"].disabled = true
		
		forms[curr_form]["model"].visible = true
		forms[curr_form]["col"].disabled = false
		
		max_speed = forms[curr_form]["speed"]
		TURN_SPEED = forms[curr_form]["turn_speed"]
		jump_speed = forms[curr_form]["jump_speed"]
		ACCEL = forms[curr_form]["accel"]
		
		#TODO play tf cutscene
	
	
func _unhandled_input(event):
	if event.is_action_pressed("click"):
		if DisplayServer.mouse_get_mode() == DisplayServer.MOUSE_MODE_VISIBLE:
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
	if is_cutscene_playing:
		return
	input_movement_vector = Input.get_vector("left", "right", "backward", "forward")
	if event.is_action_pressed("scroll_up"):
#		var curr_len = rotation_helper.get_node("SpringArm3D").spring_length
		if target_spring_length > 1.0:
			target_spring_length -= 1
		zoom_tween = Globals.get_tween(zoom_tween, self)
		zoom_tween.tween_property(springarm, "spring_length", target_spring_length, 0.25)
	if event.is_action_pressed("scroll_down"):
#		var curr_len = rotation_helper.get_node("SpringArm3D").spring_length
		if target_spring_length < 6.0:
			target_spring_length += 1
		zoom_tween = Globals.get_tween(zoom_tween, self)
		zoom_tween.tween_property(springarm, "spring_length", target_spring_length, 0.25)
	if event.is_action_pressed("jump") and is_on_floor():
		jump_requested = true
	if event.is_action_pressed("item 1"):
		change_form("knight")
	if event.is_action_pressed("item 2"):
		change_form("cow")
	if event.is_action_pressed("item 3"):
		change_form("bird")
		
	if event.is_action_pressed("interact"):
		if curr_interact_area:
			curr_interact_area.interact()
		elif dialog_callable and dialog_callable.is_valid():
			update_dialog()
		
	if event.is_action_pressed("aim mode"):
		crosshair.visible = true
	if event.is_action_released("aim mode"):
		crosshair.visible = false


func _input(event: InputEvent) -> void:
	if is_cutscene_playing:
		return
	#behaves better in _input, in unhandled it wouldn't work until the user pressed some buttons
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotation_helper.rotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY * -1))
			gimbal.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -1))
			
			var camera_rot: Vector3 = rotation_helper.rotation
			camera_rot.x = clamp(camera_rot.x, -deg_to_rad(30), deg_to_rad(70))
			rotation_helper.rotation = camera_rot
			
			
func dialog_area_entered(npc_name, the_callable):
	dialog_callable = the_callable
	curr_npc_name = npc_name
	talk_prompt.visible = true


func update_dialog():
	dialog_node.visible = true
	talk_prompt.visible = false
	if dialog_callable.is_valid() and curr_npc_name != "":
		var text = dialog_callable.call()
		dialog_label.text = "%s:\n%s" % [curr_npc_name, text]
		#sometimes the dialog goes under the screen? Need to set the size manually apparently
		dialog_label.custom_minimum_size.y = 50 * dialog_label.text.count("\n") + 100
#		dialog_label.call_deferred("update_minimum_size")
	
	
func hide_dialog():
	curr_npc_name = ""
	dialog_callable = Callable()
	dialog_node.visible = false
	dialog_label.text = ""
	talk_prompt.visible = false


func window_resize():
	var new_shader_res := Vector2(DisplayServer.window_get_size() / 2.0)
	shader.material.set_shader_parameter("resolution", new_shader_res)
