extends Node3D
class_name NPC
#Inheritors need to have a TalkArea and hook up its body_entered and body_exited signals!!

@export var npc_name := "Default NPC"

#map of dialogue. If its a string, show it. If its a callable, run it
#id -> [string/callable, next id, flags]
#flags - 0 = normal, 1 = only shown on first talk
var dialogue := {"start": ["Hi", "END", 0]}
var curr_dialog_id := "start"
var is_first_talk := true


func _on_talk_area_body_entered(body):
	body.dialog_area_entered(npc_name, Callable(self, "next_line"))


func _on_talk_area_body_exited(body):
	body.hide_dialog()
	curr_dialog_id = "start"


func next_line() -> String:
	if curr_dialog_id == "END":
		is_first_talk = false
		curr_dialog_id = "start"
		Globals.player.hide_dialog()
		
	if not is_first_talk:
		while dialogue[curr_dialog_id][2] == 1:
			curr_dialog_id = dialogue[curr_dialog_id][1]
	
	var line = dialogue[curr_dialog_id][0]
	curr_dialog_id = dialogue[curr_dialog_id][1]
	if line is String:
		return line
	elif line is Callable:
		return line.call()
	else:
		return ""
