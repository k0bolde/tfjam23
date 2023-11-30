extends Area3D

@onready var porb_marker = $Marker3D
var porb_spawned := false

func _ready():
	body_entered.connect(_body_entered)

	
func _body_entered(_body):
	if not porb_spawned:
		porb_spawned = true
		var porb = preload("res://src/porb.tscn").instantiate()
		porb_marker.add_child(porb)
