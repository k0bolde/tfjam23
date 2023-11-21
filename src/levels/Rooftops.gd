extends Level

@onready var windmill_anim : AnimationPlayer = $WindmillAnimationPlayer
@onready var windmill_button = $EggButton

func __ready():
	windmill_anim.advance(1.0)
	windmill_anim.pause()
	windmill_button.callback = windmill_anim.play
