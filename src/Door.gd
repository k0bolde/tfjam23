extends Area3D

@export var level_idx_to_load : int

func _on_body_entered(body):
	body.curr_interact_area = self


func _on_body_exited(body):
	if body.curr_interact_area == self:
		body.curr_interact_area = null


func interact():
	Globals.main.change_level(level_idx_to_load)
