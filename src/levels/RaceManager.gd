extends Node3D
class_name RaceManager
#keeps track of player and cow position in race

#These gotta be in race order
var checkpoints : Array[RaceCheckpoint]
var curr_checkpoint_idx := 0
var npc_idx := 0
var is_race_going_on := false
@export var npc_racer : Racer

func _ready():
	for child in get_children():
		checkpoints.append(child)
		
		
func start_race():
	curr_checkpoint_idx = 0
	is_race_going_on = true
	npc_racer.start_racing()
	checkpoints[curr_checkpoint_idx + 1].activate()


func passed_checkpoint(rc:RaceCheckpoint, is_player:bool):
	if is_race_going_on:
		var idx = checkpoints.find(rc)
		if is_player:
			if idx == curr_checkpoint_idx + 1:
				curr_checkpoint_idx += 1
				checkpoints[curr_checkpoint_idx].deactivate()
			if curr_checkpoint_idx == checkpoints.size() - 1:
				#race over
				is_race_going_on = false
				if curr_checkpoint_idx > npc_idx:
					#player won, spawn porb
					pass
				else:
					#cow won, put back in start pos
					pass
			else:
				checkpoints[curr_checkpoint_idx + 1].activate()
		else:
			if idx == npc_idx + 1:
				npc_idx += 1
		
