extends Node3D
class_name Main

@onready var level_node = $Level
var curr_level : Level
var levels := [preload("res://src/levels/level1.tscn"), preload("res://src/levels/level2.tscn")]


func _ready():
	Globals.main = self
	curr_level = level_node.get_child(0)


func change_level(level_idx : int):
	#TODO fade to black
	curr_level.queue_free()
	curr_level = levels[level_idx].instantiate()
	level_node.add_child(curr_level)
	Globals.player.set_deferred("global_position", curr_level.spawn_node.global_position)
#	Globals.player.global_position = curr_level.spawn_node.global_position
