extends Node3D
class_name Level
#Each level needs:
#	a node called Spawns with node3d's in it that mark entrance/exit points
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
		$Killplane.collision_mask = 2
		if not $Killplane.body_entered.is_connected(_on_killplane_body_entered):
			$Killplane.body_entered.connect(_on_killplane_body_entered)
	if has_node("IntroCutscene"):
		#might be safer to delay this until the player is loaded for sure
		$IntroCutscene.call_deferred("start_cutscene")
	#hacky way to have subclasses have their _ready (__ready()) called. Normally if a subclass has a _ready, this one won't be called
	if self.has_method("__ready"):
		call_deferred("__ready")
	
	
var respawn_wait_tween : Tween
func _on_killplane_body_entered(body):
	body.fade_in_out()
	respawn_wait_tween = Globals.get_tween(respawn_wait_tween, self)
	respawn_wait_tween.tween_interval(0.5)
	respawn_wait_tween.tween_callback(_on_respawn_timeout)
	
	
func _on_respawn_timeout():
	Globals.player.set_deferred("global_position", spawns[0].global_position)
	Globals.player.vel = Vector3()
	Globals.player.global_rotation = spawns[0].global_rotation
	Globals.player.gimbal.global_rotation = spawns[0].global_rotation
