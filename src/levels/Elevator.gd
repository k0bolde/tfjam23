extends AnimatableBody3D

@onready var intial_pos := global_position
var ele_tween : Tween

var is_moving_down := false

func _ready():
	ele_tween = Globals.get_tween(ele_tween, self)
	ele_tween.set_loops()
	ele_tween.set_trans(Tween.TRANS_SPRING).tween_property(self, "global_position:y", intial_pos.y - 20.0, 10.0)
	ele_tween.set_trans(Tween.TRANS_ELASTIC).tween_property(self, "global_position:y", intial_pos.y, 10.0)
	

func _on_area_3d_body_entered(_body):
	ele_tween = Globals.get_tween(ele_tween, self)
	ele_tween.tween_property(self, "global_position:y", intial_pos.y - 20.0, 10.0)


func _on_area_3d_body_exited(_body):
	ele_tween = Globals.get_tween(ele_tween, self)
	ele_tween.tween_property(self, "global_position:y", intial_pos.y, 10.0)
