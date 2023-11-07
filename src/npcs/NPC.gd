extends Node3D
class_name NPC

@onready var talk_area : Area3D = $TalkArea
@export var npc_name := "Default NPC"

#map of dialogue. If its a string, show it. If its a callable, run it
#id -> [string/callable, next id]
var dialogue := {"start": ["Hi", "END"]}
var curr_dialog_id := "start"


func _on_talk_area_body_entered(body):
	#TODO show interact prompt, send dialog callback to player
	pass


func _on_talk_area_body_exited(body):
	#TODO hide interact prompt
	pass 
