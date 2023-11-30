extends Area3D
class_name Checkpoint

@export var spawn_idx := 0
@onready var level = get_parent().get_parent()


func _ready():
	collision_mask = 2
	body_entered.connect(_body_entered)
	
	
func _body_entered(body):
	level.curr_checkpoint_spawn_idx = spawn_idx
