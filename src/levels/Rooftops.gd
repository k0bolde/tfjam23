extends Level

@onready var windmill_anim : AnimationPlayer = $WindmillAnimationPlayer
@onready var windmill_button = $EggButton
@onready var ferris_anim : AnimationPlayer = $FerrisAnimationPlayer


func __ready():
	windmill_anim.advance(1.0)
	windmill_anim.pause()
	windmill_button.callback = start_spin


func start_spin():
	windmill_anim.play()
	ferris_anim.play("spin")
