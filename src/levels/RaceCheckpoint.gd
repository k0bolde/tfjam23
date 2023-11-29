extends Area3D
class_name RaceCheckpoint
#TODO only show the active one
@onready var visual : MeshInstance3D = $MeshInstance3D


func _ready():
	collision_layer = 0
	collision_mask = 2 + 8
	body_entered.connect(_on_body_entered)


func activate():
	visual.visible = true
	
	
func deactivate():
	visual.visible = false


func _on_body_entered(body):
	get_parent().passed_checkpoint(self, body is Player)
