extends Area3D

func _ready():
	collision_layer = 0
	collision_mask = 2
	gravity_space_override = Area3D.SPACE_OVERRIDE_REPLACE
	gravity_direction = Vector3(0, 1, 0)
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)


func _on_body_entered(body):
	body.gravity_mult = -1.0


func _on_body_exited(body):
	body.gravity_mult = 1.0
