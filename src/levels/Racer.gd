extends Path3D

@onready var path_follow : PathFollow3D = $PathFollow3D
var is_racing := false
var delta_accum := 0.0
@export var speed := 10.0
@export var speed_curve := 0.5


func _ready():
	$PathFollow3D/AnimatableBody3D.collision_layer = 8
	$PathFollow3D/AnimatableBody3D.collision_mask = 1 + 2 + 4
	is_racing = true
	
	
func _physics_process(delta):
	if is_racing:
		delta_accum += delta * speed
		path_follow.progress = delta_accum
#		print("progress: %s" % path_follow.progress_ratio)
#		path_follow.progress_ratio = ease(delta_accum, speed_curve)
		if path_follow.progress_ratio >= 1.0:
			delta_accum = 0.0
			is_racing = false
