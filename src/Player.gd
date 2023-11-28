extends CharacterBody3D
class_name Player
#TODO investigate interpolated cam not interpolating position
#TODO anteater grapple and fishing
#TODO items attached to forms to show what tfs are availible? cow bell, . Actually use the item in the tf cutscenes
#TODO springarm blob shadow - decal?
#TODO cow dustcloud particles when vel is far enough away from vdir for drifting purposes

@onready var rotation_helper = $Gimbal/RotationHelper
@onready var gimbal = $Gimbal
@onready var gimbal_origin : Vector3 = gimbal.transform.origin
@onready var camera : Camera3D = $Gimbal/RotationHelper/SpringArm3D/Camera3D
@onready var interp_cam : InterpolatedCamera3D = $Gimbal/RotationHelper/SpringArm3D/InterpolatedCamera3D
@onready var springarm : SpringArm3D = $Gimbal/RotationHelper/SpringArm3D
@onready var dialog_node : Control = %Dialog
@onready var dialog_label : Label = %DialogLabel
@onready var talk_prompt : Control = %TalkPrompt
@onready var next_prompt : Control = %NextPrompt
@onready var prompt_label : Label = %PromptLabel
@onready var shader : TextureRect = %ShaderRect
@onready var crosshair : TextureRect = %Crosshair
@onready var black_fade : ColorRect = %BlackFade
@onready var white_fade : ColorRect = %WhiteFade
@onready var pause_menu : Control = $CanvasLayer/PauseMenu
@onready var tf_cutscene = $TFCutscene
@onready var cow_skelly : Skeleton3D = $Models/cow/metarig/Skeleton3D

var MOUSE_SENSITIVITY := 0.1
var TURN_SPEED := 0.05
var max_speed := 10.0
var ACCEL := 0.05
var DEACCEL := 0.1
var jump_speed := 12.0
var in_air_time := 0.0
var coyote_time := 0.15
var jump_held_time := 0.0
var low_grav_time := 0.5
var input_movement_vector : Vector2
var player_dir := Vector3()
var vdir := Vector3()
var last_vdir := Vector3()
var vel := Vector3()
var zoom_tween : Tween
var jump_requested := false
var target_spring_length := 2.0
var is_cutscene_playing := false
var gravity_mult := 1.0
var is_crouching := false
var udder_size := 1.0
var udder_fill_rate := 0.1
var udder_max_size := 1.5
var udder_min_size := 0.3
var udder_bone_idx := 0
var eggs := 6.0
var egg_fill_rate := 0.5
var eggs_max := 6.0

var curr_form := "knight"
var last_form := "knight"
var forms := {"knight": {}, "cow": {}, "bird": {}}
var is_tfing := false
var is_form_locked := false
@onready var curr_anim : AnimationPlayer = $Models/knight/AnimationPlayer
var egg_scene = preload("res://src/Egg.tscn")
var white_fade_tween : Tween
var porbs := 0

var dialog_callable : Callable
var curr_npc_name : String
var pickup_callable : Callable
var door_callable : Callable
var interact_callable : Callable

func _ready():
	Globals.player = self
	udder_bone_idx = cow_skelly.find_bone("udder")
	
	forms["knight"]["model"] = $Models/knight
	forms["cow"]["model"] = $Models/cow
	forms["bird"]["model"] = $Models/bird
	
	forms["knight"]["anims"] = $Models/knight/AnimationPlayer
	forms["cow"]["anims"] = $Models/cow/AnimationPlayer
	forms["bird"]["anims"] = $Models/bird/AnimationPlayer
	$Models/knight/AnimationPlayer.animation_finished.connect(_anim_finished)
	$Models/cow/AnimationPlayer.animation_finished.connect(_anim_finished)
	$Models/bird/AnimationPlayer.animation_finished.connect(_anim_finished)
	
	forms["knight"]["tf_item"] = "helmet"
	forms["cow"]["tf_item"] = "cowbell"
	forms["bird"]["tf_item"] = "feather"
	
	forms["knight"]["col"] = $KnightCollision
	forms["cow"]["col"] = $CowCollision2
	forms["bird"]["col"] = $KnightCollision
	forms["knight"]["crouch_col"] = $KnightCrouchCollision
	forms["cow"]["crouch_col"] = $KnightCrouchCollision
	forms["bird"]["crouch_col"] = $KnightCrouchCollision

	forms["knight"]["speed"] = 10.0
	forms["cow"]["speed"] = 40.0
	forms["bird"]["speed"] = 16.0
	
	forms["knight"]["turn_speed"] = 0.06
	forms["cow"]["turn_speed"] = 0.03
	forms["bird"]["turn_speed"] = 0.1
	
	forms["knight"]["jump_speed"] = 12.0
	forms["cow"]["jump_speed"] = 8.0
	forms["bird"]["jump_speed"] = 16.0
	
	forms["knight"]["accel"] = 0.05
	forms["cow"]["accel"] = 0.005
	forms["bird"]["accel"] = 0.1
	
	forms["knight"]["owned"] = true
	forms["cow"]["owned"] = true
	forms["bird"]["owned"] = true

	change_form("knight")
	
	RenderingServer.viewport_set_scaling_3d_scale(get_viewport().get_viewport_rid(), 0.5)
	get_viewport().size_changed.connect(window_resize)
	window_resize()
	
#	tf_cutscene.get_node("Camera3D").current = true


func _physics_process(delta):
	gimbal.global_position = global_position + Vector3(0, 1.5, 0)
	var cam_xform := camera.get_global_transform()
	var clamped_move_vec := input_movement_vector.normalized()
	if is_cutscene_playing:
		clamped_move_vec = Vector2()
	var dir := Vector3()
	dir += -cam_xform.basis.z * clamped_move_vec.y
	dir += cam_xform.basis.x * clamped_move_vec.x
	dir.y = 0.0
	if is_on_floor():
		in_air_time = 0.0
		if jump_requested:
			jump_requested = false
			vel.y = jump_speed
			var plat_vel = get_platform_velocity()
			if plat_vel.y < 0:
				plat_vel.y = 0
			vel += plat_vel
			curr_anim.play("Jump")
		elif is_equal_approx(gravity_mult, 1.0):
			vel.y = 0.0
		else:
			vel.y -= 1.0 * gravity_mult
	else:
		in_air_time += delta
		if jump_requested and in_air_time < coyote_time:
			vel.y = jump_speed
			vel += get_platform_velocity()
			curr_anim.play("Jump")
		else:
			if Input.is_action_pressed("jump"):
				jump_held_time += delta
				if jump_held_time < low_grav_time or curr_form == "bird":
					vel.y -= 0.5 * gravity_mult
				else:
					vel.y -= 1.0 * gravity_mult
			else:
				vel.y -= 1.0 * gravity_mult
		jump_requested = false
	var hvel := vel
	hvel.y = 0
	if not is_cutscene_playing:
		if vel.y < 0.0:
			if curr_anim.has_animation("Fall"):
				curr_anim.play("Fall")
			else:
				curr_anim.play("Falling")
		elif is_zero_approx(vel.y):	
			if hvel.length_squared() > 0.5:
				curr_anim.play("Run")
			else:
				curr_anim.play("Idle")
	
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
	
	if is_crouching and forms[curr_form]["crouch_col"].disabled:
		forms[curr_form]["crouch_col"].disabled = false
		forms[curr_form]["col"].disabled = true
	elif not is_crouching and forms[curr_form]["col"].disabled:
		forms[curr_form]["crouch_col"].disabled = true
		forms[curr_form]["col"].disabled = false
		
	move_and_slide()
	
	vdir += get_platform_angular_velocity()
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
		
	if get_last_slide_collision():
		var collider = get_last_slide_collision().get_collider()
		if collider.has_method("player_touched"):
			collider.player_touched(self)
		elif collider.get_parent().has_method("player_touched"):
			collider.get_parent().player_touched(self)
	
	
func change_form(new_form:String, is_locking := false):
	if is_form_locked:
		#TODO feedback that you're locked
		return
	is_form_locked = is_locking
	%CursedLabel.visible = is_form_locked
	if forms.keys().has(new_form) and curr_form != new_form and forms[new_form]["owned"] == true:
		last_form = curr_form
		curr_form = new_form
		%FormLabel.text = "%s Form" % curr_form.capitalize()
		%CountLabel.visible = curr_form != "knight"
		
		max_speed = forms[curr_form]["speed"]
		TURN_SPEED = forms[curr_form]["turn_speed"]
		jump_speed = forms[curr_form]["jump_speed"]
		ACCEL = forms[curr_form]["accel"]
		
		if curr_form == "cow":
			floor_block_on_wall = false
		else:
			floor_block_on_wall = true
		
		#TODO hide/show owned tf item on hip bone attachment
		is_cutscene_playing = true
		tf_cutscene.visible = true
		tf_cutscene.get_node("Camera3D").current = true
		tf_cutscene.get_node("AnimationPlayer").play("zoom")
		white_fade_tween = Globals.get_tween(white_fade_tween, self)
		white_fade_tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
		white_fade_tween.tween_property(white_fade, "modulate", Color.WHITE, 4.0)
		if curr_anim.has_animation("tf"):
			curr_anim.play("tf")
		else:
			_anim_finished("tf")
		
		
	
func _unhandled_input(event):
	input_movement_vector = Input.get_vector("left", "right", "backward", "forward")
	if is_cutscene_playing:
		return
	if event.is_action_pressed("scroll_up"):
		if target_spring_length > 1.0:
			target_spring_length -= 1
		zoom_tween = Globals.get_tween(zoom_tween, self)
		zoom_tween.tween_property(springarm, "spring_length", target_spring_length, 0.25)
	if event.is_action_pressed("scroll_down"):
		if target_spring_length < 6.0:
			target_spring_length += 1
		zoom_tween = Globals.get_tween(zoom_tween, self)
		zoom_tween.tween_property(springarm, "spring_length", target_spring_length, 0.25)
	if event.is_action_pressed("jump"):
		jump_requested = true
		jump_held_time = 0.0
	if event.is_action_pressed("item 1"):
		change_form("knight")
	if event.is_action_pressed("item 2"):
		change_form("cow")
	if event.is_action_pressed("item 3"):
		change_form("bird")
	if event.is_action_pressed("item 4"):
		change_form("anteater")
		
	if event.is_action_pressed("interact"):
		if door_callable and door_callable.is_valid():
			door_callable.call()
		elif dialog_callable and dialog_callable.is_valid():
			update_dialog()
		elif pickup_callable and pickup_callable.is_valid():
			pickup_item()
		elif interact_callable and interact_callable.is_valid():
			interact_callable.call()
		
#	if event.is_action_pressed("crouch"):
#		is_crouching = true
#	if event.is_action_released("crouch"):
#		is_crouching = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if DisplayServer.mouse_get_mode() == DisplayServer.MOUSE_MODE_VISIBLE:
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)
	if is_cutscene_playing:
		return
	if event.is_action_pressed("click"):
		if crosshair.visible:
			if curr_form == "bird":
				if eggs >= 1.0:
					#shoot egg where camera is facing
					var egg : RigidBody3D = egg_scene.instantiate()
					Globals.main.eggs.add_child(egg)
					var pos = global_position
					pos.y += 0.5
					egg.global_position = pos
					egg.rotation.y = gimbal.rotation.y
					var y_vel = remap(rotation_helper.rotation.x, deg_to_rad(0), deg_to_rad(70), 0.0, 30.0)
					egg.linear_velocity = Vector3(0, y_vel, -20.0).rotated(Vector3.UP, gimbal.rotation.y) + vel
					eggs -= 1.0
			elif curr_form == "cow":
				#shoot milk, shrink udder
				#TODO if in air, shoot down and doublejump?
				if udder_size > udder_min_size + 0.3:
					var milk_drop = preload("res://src/MilkDrop.tscn").instantiate()
					Globals.main.eggs.add_child(milk_drop)
					var pos = global_position
					pos.y += 0.5
					milk_drop.global_position = pos
					milk_drop.rotation.y = gimbal.rotation.y
					if is_on_floor():
						var y_vel = remap(rotation_helper.rotation.x, deg_to_rad(0), deg_to_rad(70), 0.0, 30.0)
						milk_drop.linear_velocity = Vector3(0, y_vel, -10.0).rotated(Vector3.UP, gimbal.rotation.y) + vel
					else:
						#shoot down and push player up
						vel.y = jump_speed
						milk_drop.linear_velocity = Vector3(0, -5, 0)
					udder_size -= 0.3
				
				
	if event.is_action_pressed("aim mode"):
		crosshair.visible = true
		#TODO zoom in while aiming so player can't see where the egg spawns at
#		camera.fov = 30
	if event.is_action_released("aim mode"):
		crosshair.visible = false
#		camera.fov = 75
	#behaves better in _input, in unhandled it wouldn't work until the user pressed some buttons
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotation_helper.rotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY * -1))
			gimbal.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -1))
			
			var camera_rot: Vector3 = rotation_helper.rotation
			camera_rot.x = clamp(camera_rot.x, -deg_to_rad(30), deg_to_rad(70))
			rotation_helper.rotation = camera_rot
			
			
func _process(delta):
	if curr_form == "cow":
		udder_size += udder_fill_rate * delta
		if udder_size > udder_max_size:
			udder_size = udder_max_size
			#TODO milksplosion
		cow_skelly.set_bone_pose_scale(udder_bone_idx, Vector3.ONE * udder_size)
		%CountLabel.text = "%d Milk Squirts" % floori((udder_size - udder_min_size) / 0.3)
	elif curr_form == "bird":
		if eggs < eggs_max:
			eggs += egg_fill_rate * delta
		%CountLabel.text = "%d Eggs" % eggs
			
			
func dialog_area_entered(npc_name, the_callable):
	dialog_callable = the_callable
	curr_npc_name = npc_name
	talk_prompt.visible = true
	prompt_label.text = "Talk (E)"


func update_dialog():
	dialog_node.visible = true
	talk_prompt.visible = false
	if dialog_callable.is_valid() and curr_npc_name != "":
		var text = dialog_callable.call()
		dialog_label.text = "%s:\n%s" % [curr_npc_name, text]
		#sometimes the dialog goes under the screen? Need to set the size manually apparently
		dialog_label.custom_minimum_size.y = 50 * dialog_label.text.count("\n") + 100
	
	
func hide_dialog():
	curr_npc_name = ""
	dialog_callable = Callable()
	dialog_node.visible = false
	dialog_label.text = ""
	talk_prompt.visible = false


func pickup_area_entered(the_callable : Callable):
	talk_prompt.visible = true
	prompt_label.text = "Pick Up (E)"
	pickup_callable = the_callable
	
	
func door_area_entered(the_callable:Callable):
	door_callable = the_callable
	prompt_label.text = "Enter (E)"
	talk_prompt.visible = true
	
	
func interact_area_entered(the_prompt:String, the_callable:Callable):
	prompt_label.text = the_prompt
	talk_prompt.visible = true
	interact_callable = the_callable
	
	
func interact_area_exited():
	interact_callable = Callable()
	talk_prompt.visible = false	


func door_area_exited():
	door_callable = Callable()
	talk_prompt.visible = false


func pickup_item():
	var item_info : Dictionary = pickup_callable.call()
	if item_info["type"] == "new form":
		forms[item_info["form_name"]]["owned"] = true
		change_form(item_info["form_name"], true)


func window_resize():
	var new_shader_res := Vector2(DisplayServer.window_get_size() / 2.0)
	shader.material.set_shader_parameter("resolution", new_shader_res)


func in_path_follow(is_starting:bool):
	is_cutscene_playing = is_starting
	if is_starting:
		gravity_mult = 0.0
	else:
		gravity_mult = 1.0


var fade_tween : Tween
func fade_in_out():
	fade_tween = Globals.get_tween(fade_tween, self)
	fade_tween.set_trans(Tween.TRANS_SINE)
	fade_tween.tween_property(black_fade, "modulate", Color.WHITE, 0.5)
	fade_tween.tween_property(black_fade, "modulate", Color.TRANSPARENT, 2.0)


func _anim_finished(anim_name):
	if anim_name == "tf":
		is_cutscene_playing = false
		tf_cutscene.visible = false
		interp_cam.current = true
		forms[last_form]["model"].visible = false
		forms[curr_form]["model"].visible = true
		#if we're formlocked, don't show the other tf items
		for form in forms:
			if form != curr_form and curr_form != "knight":
				forms[curr_form]["model"].get_node("metarig/Skeleton3D/HipAttachment/%s" % forms[form]["tf_item"]).visible = not is_form_locked and forms[form]["owned"]
		curr_anim.stop()
		curr_anim = forms[curr_form]["anims"]
		forms[last_form]["col"].disabled = true
		forms[curr_form]["col"].disabled = false
		white_fade_tween = Globals.get_tween(white_fade_tween, self)
		white_fade_tween.set_ease(Tween.EASE_IN)
		white_fade_tween.tween_property(white_fade, "modulate", Color.TRANSPARENT, 2.0)


func collect_porb():
	porbs += 1
	update_porbs()
	
	
func update_porbs():
	%OrbLabel.text = "Orbs %d/3" % porbs
