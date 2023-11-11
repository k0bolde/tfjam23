extends Area3D

#refers to the index in the array of levels in Main
@export var level_idx_to_load := 0
@export var spawn_idx := 0

@onready var animplayer : AnimationPlayer = $AnimationPlayer

func _on_body_entered(body):
	body.door_area_entered(interact)
	animplayer.play("open")


func _on_body_exited(body):
	body.door_area_exited()
	animplayer.play_backwards("open")


func interact():
	Globals.main.change_level(level_idx_to_load, spawn_idx)
