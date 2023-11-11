extends Node3D
class_name Level
#Each level needs:
#	a node called Spawn or set in the export
#	its own WorldEnvironment
#	optionally a killplane
#	optionally an IntroCutscene
#TODO don't play intro cutscene when the level's already been visited once?
#TODO respawn on last solid ground when hitting killplane

var spawns := []

func _ready():
	if has_node("Spawns"):
		for child in $Spawns.get_children():
			spawns.append(child)
	if has_node("Killplane"):
		if not $Killplane.body_entered.is_connected(_on_killplane_body_entered):
			$Killplane.body_entered.connect(_on_killplane_body_entered)
	if has_node("IntroCutscene"):
		#might be safer to delay this until the player is loaded for sure
		$IntroCutscene.call_deferred("start_cutscene")
	

func _on_killplane_body_entered(body):
	body.set_deferred("global_position", spawns[0].global_position)
	body.vel = Vector3()
