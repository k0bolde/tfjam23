extends Area3D


func _ready():
	body_entered.connect(_body_entered)
	
	
func _body_entered(_body):
	var t : Tween
	t = Globals.get_tween(t, self)
	t.tween_property(get_parent().get_node("CanvasLayer/Control"), "modulate", Color.WHITE, 3.0)
	t.tween_interval(5.0)
	t.tween_callback(get_tree().change_scene_to_file.bind("res://src/Title.tscn"))
	
