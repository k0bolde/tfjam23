extends Level


func __ready():
	$EggButton.callback = rotate_plat
	
	
func rotate_plat():
	var t : Tween
	t = Globals.get_tween(t, self)
	t.set_trans(Tween.TRANS_SINE)
	t.tween_property($Cube_001, "rotation:x", 0, 5.0)
	t.set_parallel().tween_property($Cube_003, "position:y", 25.0, 5.0)
