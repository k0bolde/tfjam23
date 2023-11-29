extends Path3D
class_name Racer
#TODO start race after talking to
#TODO keep track of race position - race checkpoint tracker

@onready var path_follow : PathFollow3D = $PathFollow3D
@onready var anims : AnimationPlayer = $PathFollow3D/Cow1/cow/AnimationPlayer
var is_racing := false
var delta_accum := 0.0
@export var speed := 15.0
@export var speed_curve := 0.5


#func _ready():
#	is_racing = true
	
func start_racing():
	is_racing = true
	anims.play("Run")
	
	
func stop_racing():
	is_racing = false
	delta_accum = 0.0
	path_follow.progress = 0
	anims.play("Idle")
	
	
func _physics_process(delta):
	if is_racing:
		delta_accum += delta * speed
		path_follow.progress = delta_accum
#		print("progress: %s" % path_follow.progress_ratio)
#		path_follow.progress_ratio = ease(delta_accum, speed_curve)
		if path_follow.progress_ratio >= 1.0:
			stop_racing()
