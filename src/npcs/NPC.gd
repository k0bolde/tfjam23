extends Node3D
class_name NPC
#Inheritors need to have a TalkArea and hook up its body_entered and body_exited signals!!

@export var npc_name := "Default NPC"

#map of dialogue. If its a string, show it. If its a callable, run it
#id -> [string/callable, next id]
var dialogue := {"start": ["Hi", "END"]}
var curr_dialog_id := "start"


func _on_talk_area_body_entered(body):
	body.dialog_area_entered(npc_name, Callable(self, "next_line"))


func _on_talk_area_body_exited(body):
	body.hide_dialog()
	curr_dialog_id = "start"


func next_line() -> String:
	if curr_dialog_id == "END":
		curr_dialog_id = "start"
		return "DIALOG END - LOOPING"
	var line = dialogue[curr_dialog_id][0]
	curr_dialog_id = dialogue[curr_dialog_id][1]
	if line is String:
		return line
	elif line is Callable:
		return line.call()
	else:
		return ""
