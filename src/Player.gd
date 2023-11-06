extends CharacterBody3D

@onready var rotation_helper = $Gimbal/RotationHelper
@onready var gimbal = $Gimbal
@onready var gimbal_origin : Vector3 = gimbal.transform.origin
@onready var camera : Camera3D = $Gimbal/RotationHelper/SpringArm3D/InterpolatedCamera3D
@onready var springarm : SpringArm3D = $Gimbal/RotationHelper/SpringArm3D

var MOUSE_SENSITIVITY := 0.1
var TURN_SPEED := 0.1
var speed := 10.0
var jump_speed := 12.0
var input_movement_vector : Vector2
var player_dir := Vector3()
var vdir := Vector3()
var last_vdir := Vector3()
var zoom_tween : Tween
var jump_requested := false

var curr_form := "knight"
var forms := ["knight", "cow", "anteater", "messenger"]


func _ready():
	Globals.player = self


func _physics_process(delta):
	var cam_xform := camera.get_global_transform()
	var clamped_move_vec := input_movement_vector.normalized()
	var dir := Vector3()
	dir += -cam_xform.basis.z * clamped_move_vec.y
	dir += cam_xform.basis.x * clamped_move_vec.x
	dir.y = 0.0
	if not is_on_floor():
		dir.y -= 1
	else:
		dir.y = 0.0
	if jump_requested:
		jump_requested = false
		if is_on_floor():
			dir.y += jump_speed
		
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
	
	#TODO accel
	velocity = dir * speed
	move_and_slide()
	
	last_vdir = vdir
	var look_vec = vdir + get_transform().origin
#	#only change look_at if its not already looking at the thing. Uses the built in check look_at uses
	if (input_movement_vector.length() > 0.0 and Vector3.UP.cross(vdir) != Vector3.ZERO):
		look_at(look_vec)
	#		lock to only y rotation, got extra z and x we don't need from the look_at
		var my_rot = get_rotation()
		my_rot.x = 0
		my_rot.z = 0
		set_rotation(my_rot)
	gimbal.global_position = global_position + Vector3(0, 1.5, 0)
	
	
func change_form(new_form:String):
	if forms.has(new_form):
		curr_form = new_form
		#TODO play tf cutscene
		#TODO change model
	
	
func _unhandled_input(event):
	if event.is_action_pressed("click"):
		if DisplayServer.mouse_get_mode() == DisplayServer.MOUSE_MODE_VISIBLE:
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
	input_movement_vector = Input.get_vector("left", "right", "backward", "forward")
	if event.is_action_pressed("scroll_up"):
		var curr_len = rotation_helper.get_node("SpringArm3D").spring_length
		if curr_len > 1.0:
			curr_len -= 1
		zoom_tween = Globals.get_tween(zoom_tween, self)
		zoom_tween.tween_property(springarm, "spring_length", curr_len, 0.25)
	if event.is_action_pressed("scroll_down"):
		var curr_len = rotation_helper.get_node("SpringArm3D").spring_length
		if curr_len < 6.0:
			curr_len += 1
		zoom_tween = Globals.get_tween(zoom_tween, self)
		zoom_tween.tween_property(springarm, "spring_length", curr_len, 0.25)
	#TODO inventory open/close
	#TODO scroll to adjust cam length
	#TODO jump
	if event.is_action_pressed("jump"):
		jump_requested = true


func _input(event: InputEvent) -> void:
	#behaves better in _input, in unhandled it wouldn't work until the user pressed some buttons
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotation_helper.rotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY * -1))
			gimbal.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -1))
			
			var camera_rot: Vector3 = rotation_helper.rotation
			camera_rot.x = clamp(camera_rot.x, -deg_to_rad(30), deg_to_rad(70))
			rotation_helper.rotation = camera_rot
