extends Node3D

@onready var path_follow : PathFollow3D = $Path3D/PathFollow3D
@onready var area : Area3D = $Area3D
var is_animating := false
var speed := 0.5
var delta_accum := 0.0


func _ready():
	area.body_entered.connect(_on_body_entered)
	area.collision_mask = 2
	area.collision_layer = 0
	path_follow.loop = false
	
	
func _on_body_entered(body):
	body.reparent(path_follow)
	body.in_path_follow(true)
	is_animating = true
	
	
func _physics_process(delta):
	if is_animating:
		delta_accum += delta * speed
		path_follow.progress_ratio = ease(delta_accum, -0.5)
		if path_follow.progress_ratio >= 1:
			is_animating = false
			Globals.player.reparent(Globals.main)
			Globals.player.in_path_follow(false)
			path_follow.set_deferred("progress_ratio", 0.0)
			delta_accum = 0.0
			Globals.player.gimbal.rotation.x = 0.0
			Globals.player.gimbal.rotation.z = 0.0
			Globals.player.vel = Vector3()
