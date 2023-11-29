extends Node3D
class_name RaceManager
#keeps track of player and cow position in race

#These gotta be in race order
var checkpoints : Array[RaceCheckpoint]
var curr_checkpoint_idx := 0
var npc_idx := 0
var is_race_going_on := false
@export var npc_racer : Racer
var porb_spawned := false
@export var porb_marker : Node3D


func _ready():
	for child in get_children():
		checkpoints.append(child)
		
		
func start_race():
	if not is_race_going_on and not porb_spawned:
		curr_checkpoint_idx = 0
		is_race_going_on = true
		npc_racer.start_racing()
		checkpoints[curr_checkpoint_idx + 1].activate()
		
		
func finish_race():
	if curr_checkpoint_idx > npc_idx:
		#player won, spawn porb
		var porb = preload("res://src/porb.tscn").instantiate()
		porb_marker.add_child(porb)
		porb_spawned = true
		checkpoints[curr_checkpoint_idx].deactivate()
		is_race_going_on = false
		#TODO change dialogue
	else:
		#cow won, don't have to do anything
		#TODO change dialogue
		pass
	

func passed_checkpoint(rc:RaceCheckpoint, is_player:bool):
	if is_race_going_on:
		var idx = checkpoints.find(rc)
		if is_player:
			if idx == curr_checkpoint_idx + 1:
				curr_checkpoint_idx += 1
				checkpoints[curr_checkpoint_idx].deactivate()
			if curr_checkpoint_idx == checkpoints.size() - 1:
				#race over
				finish_race()
			else:
				checkpoints[curr_checkpoint_idx + 1].activate()
		else:
			if idx == npc_idx + 1:
				npc_idx += 1
			if npc_idx == checkpoints.size() - 1:
				finish_race()
