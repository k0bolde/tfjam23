extends Level

@onready var windmill_anim : AnimationPlayer = $WindmillAnimationPlayer
@onready var windmill_button = $EggButton
@onready var ferris_anim : AnimationPlayer = $FerrisAnimationPlayer


func __ready():
	windmill_anim.advance(1.0)
	windmill_anim.pause()
	windmill_button.callback = start_spin
	$EggButton2.callback = rotate_platform1
	$EggButton3.callback = rotate_platform2


func start_spin():
	windmill_anim.play()
	ferris_anim.play("spin")


func rotate_platform1():
	var t : Tween
	t = Globals.get_tween(t, self)
	t.set_trans(Tween.TRANS_SINE)
	t.tween_property($CubeAnimatableBody3D, "rotation:y", deg_to_rad(-90), 2.0)


func rotate_platform2():
	var t : Tween
	t = Globals.get_tween(t, self)
	t.set_trans(Tween.TRANS_SINE)
	t.tween_property($Cube2AnimatableBody3D, "rotation:y", deg_to_rad(90), 2.0)
