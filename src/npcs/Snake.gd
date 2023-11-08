extends NPC

@onready var animplayer : AnimationPlayer = $Snake/AnimationPlayer

func _ready():
	$TalkArea.body_entered.connect(_on_talk_area_body_entered)
	$TalkArea.body_exited.connect(_on_talk_area_body_exited)
	npc_name = "T-Shirt Snake"
	dialogue = { "start": ["Can't believe all I got was a damn shirt", "line2"],
				"line2": ["And it doesn't even fit me anymore!", "END"]
				}
	animplayer.play("Snake_Idle")
