extends Level

@onready var exit_point = $ExitPoint
@onready var power_label : Label3D = $PowerLabel
@onready var cutscene = $Cutscene
var giblets := 0
var required_giblets := 3

func __ready():
	cutscene.end_callback = cutscene_finished


func _on_deposit_area_body_entered(body):
	#give body interact_callback
	body.interact_area_entered("Insert Power Ball (E)", power_inserted)


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
	#TODO check if player has them, remove one
	giblets += 1
	power_label.text = "POWER ORBS: %d/3" % giblets
	
	
func cutscene_finished():
	pass
