extends Node3D
class_name Main
#To add more levels, add to the levels array

@onready var level_node = $Level
@onready var eggs = $Eggs
var curr_level : Level
var curr_level_idx := 0
var levels := [
	preload("res://src/levels/level1.tscn"), #outside
	preload("res://src/levels/level2.tscn"), #test level
	preload("res://src/levels/Level3.tscn"), #rooftops
	preload("res://src/levels/level4.tscn"), #cow race
	preload("res://src/levels/level5.tscn"), #tower ascention
	preload("res://src/levels/DecurseRoom.tscn"),
	preload("res://src/levels/atrium.tscn")
	
	]


func _ready():
	Globals.main = self
	change_level(6, 0)
#	curr_level = level_node.get_child(0)
	

func change_level(level_idx : int, spawn_idx := 0):
	#TODO fade to black
	for egg in eggs.get_children():
		egg.queue_free()
	if curr_level:
		curr_level.queue_free()
	curr_level = levels[level_idx].instantiate()
	curr_level_idx = level_idx
	level_node.add_child(curr_level)
	var spawn = curr_level.spawns[spawn_idx]
	Globals.player.set_deferred("global_position", spawn.global_position)
	Globals.player.set_deferred("global_rotation", spawn.global_rotation)
	Globals.player.vdir = Vector3()
	Globals.player.vel = Vector3()
	Globals.player.gimbal.set_deferred("global_rotation", spawn.global_rotation)
