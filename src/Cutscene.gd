extends Path3D
class_name Cutscene
#TODO cam lookat target. Maybe another path?

var path_follow : PathFollow3D
var camera : Camera3D


@export var time_to_path := 10.0
@export var ease_type := 0.5
var is_playing := false
var accum_delta := 0.0
var end_callback : Callable


func _ready():
	path_follow = PathFollow3D.new()
	path_follow.loop = false
	add_child(path_follow)
	camera = Camera3D.new()
	path_follow.add_child(camera)
	
	
func start_cutscene():
	camera.current = true
	Globals.player.is_cutscene_playing = true
	is_playing = true
	
	
func stop_cutscene():
	Globals.player.interp_cam.current = true
	Globals.player.is_cutscene_playing = false	
	is_playing = false
	accum_delta = 0.0
	path_follow.progress_ratio = 0.0
	if end_callback.is_valid():
		end_callback.call()


func _process(delta):
	if is_playing:
		accum_delta += delta
		if accum_delta > time_to_path:
			stop_cutscene()
		path_follow.progress_ratio = ease(accum_delta / time_to_path, ease_type)
