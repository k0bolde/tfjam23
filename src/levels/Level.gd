extends Node3D
class_name Level
#Each level needs:
#	a node called Spawn or set in the export
#	its own WorldEnvironment
#	a killplane with connected

@export var spawn_node : Node3D

func _ready():
	if has_node("Spawn"):
		spawn_node = get_node("Spawn")
	if has_node("Killplane"):
		get_node("Killplane").body_entered.connect(_on_killplane_body_entered)
	

func _on_killplane_body_entered(body):
	body.set_deferred("global_position", spawn_node.global_position)
