extends Area3D


func _on_body_entered(body):
	body.gravity_mult = -1.0


func _on_body_exited(body):
	body.gravity_mult = 1.0
