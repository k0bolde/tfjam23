extends Node3D
class_name Main
#To add more levels, add to the levels array

@onready var level_node = $Level
@onready var eggs = $Eggs
var curr_level : Level
var curr_level_idx := 0
var levels := [
	preload("res://src/levels/level1.tscn"), #0 outside
	preload("res://src/levels/level2.tscn"), #1 test level
	preload("res://src/levels/Level3.tscn"), #2 rooftops
	preload("res://src/levels/level4.tscn"), #3 cow race
	preload("res://src/levels/level5.tscn"), #4 tower ascention
	preload("res://src/levels/DecurseRoom.tscn"), #5
	preload("res://src/levels/atrium.tscn"), #6 hub
	preload("res://src/levels/cow_pedestal.tscn"), #7 interim room to hold forced tf items
	preload("res://src/levels/bird_pedestal.tscn"), #8 interim room to hold forced tf items
	
	]


func _ready():
	Globals.main = self
	change_level(6, 1)
	

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
