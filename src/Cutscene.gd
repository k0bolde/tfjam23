extends Path3D
class_name Cutscene

var path_follow : PathFollow3D
var camera : Camera3D

@export var time_to_path := 10.0
var is_playing := false
var accum_delta := 0.0


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
	Globals.player.camera.current = true
	Globals.player.is_cutscene_playing = false	
	is_playing = false
	accum_delta = 0.0


func _process(delta):
	if is_playing:
		accum_delta += delta
		if accum_delta > time_to_path:
			stop_cutscene()
		path_follow.progress_ratio = accum_delta / time_to_path
