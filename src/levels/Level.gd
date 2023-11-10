extends Node3D
class_name Level
#Each level needs:
#	a node called Spawn or set in the export
#	its own WorldEnvironment
#	a killplane with connected

@export var spawn_node : Node3D

func _ready():
	if has_node("Spawn"):
		spawn_node = $Spawn
	if has_node("Killplane"):
		if not $Killplane.body_entered.is_connected(_on_killplane_body_entered):
			$Killplane.body_entered.connect(_on_killplane_body_entered)
	if has_node("IntroCutscene"):
#		$IntroCutscene.start_cutscene()
		$IntroCutscene.call_deferred("start_cutscene")
	

func _on_killplane_body_entered(body):
	body.set_deferred("global_position", spawn_node.global_position)
