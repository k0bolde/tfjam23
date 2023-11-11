extends Area3D

@export var level_idx_to_load : int

func _on_body_entered(body):
	body.door_area_entered(interact)


func _on_body_exited(body):
	body.door_area_exited()


func interact():
	Globals.main.change_level(level_idx_to_load)
