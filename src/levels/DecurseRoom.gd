extends Level
#TODO cutscene
#TODO test

@onready var exit_point = $ExitPoint
@onready var power_label : Label3D = $PowerLabel
@onready var cutscene = $Cutscene
var giblets := 0
var required_giblets := 3


func __ready():
	cutscene.end_callback = cutscene_finished
	Globals.level_state[name] = {"porbs": 0}


func _on_deposit_area_body_entered(body):
	#give body interact_callback
	body.interact_area_entered("Insert Power Orb (E)", power_inserted)


func _on_deposit_area_body_exited(body):
	#hide interact prompt
	body.interact_area_exited()


func _on_machine_area_body_entered(body):
	#if player has enough giblets, start cutscene and unformlock them
	#else respawn?
	if giblets >= required_giblets:
		cutscene.start_cutscene()
	else:
		_on_killplane_body_entered(Globals.player)


func power_inserted():
	#TODO play an animation
	if Globals.player.porbs > 0:
		Globals.player.porbs -= 1
		Globals.player.update_porbs()
		giblets += 1
		Globals.level_state[name]["porbs"] = giblets
		power_label.text = "POWER ORBS: %d/3" % giblets
	
	
func cutscene_finished():
	giblets = 0
	Globals.level_state[name]["porbs"] = giblets
	power_label.text = "POWER ORBS: %d/3" % giblets
	
	Globals.player.global_position = exit_point.global_position
	Globals.player.global_rotation = exit_point.global_rotation
	Globals.player.gimbal.global_rotation = exit_point.global_rotation
	
	Globals.player.is_form_locked = false
	Globals.player.change_form("knight")
