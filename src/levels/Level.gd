extends Node3D
class_name Level

@export var spawn_node : Node3D


func _on_killplane_body_entered(body):
	body.set_deferred("global_position", spawn_node.global_position)
