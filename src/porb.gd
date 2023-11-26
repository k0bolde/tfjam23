extends Node3D

@onready var pickup_area : Area3D = $PickupArea
@onready var initial_y = position.y
var t : Tween
var t2 : Tween


func _ready():
	pickup_area.collision_mask = 2
	pickup_area.body_entered.connect(_pickup_area_entered)
	t = Globals.get_tween(t, self)
	t.set_loops().set_trans(Tween.TRANS_SINE)
	t.tween_property(self, "position:y", initial_y + 0.5, 5)
	t.tween_property(self, "position:y", initial_y - 0.5, 5)
	t2 = Globals.get_tween(t2, self)
	t2.set_loops()
	t2.tween_property(self, "rotation:y", deg_to_rad(360), 6)
	t2.tween_property(self, "rotation:y", 0, 0.001)
	
	
func _pickup_area_entered(body):
	pass
