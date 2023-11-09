extends NPC

@onready var animplayer : AnimationPlayer = $Snake/AnimationPlayer


func _ready():
	$TalkArea.body_entered.connect(_on_talk_area_body_entered)
	$TalkArea.body_exited.connect(_on_talk_area_body_exited)
	npc_name = "T-Shirt Snake"
	animplayer.playback_default_blend_time = 0.1
	animplayer.play("Snake_Idle")
	dialogue = { "start": [Callable(self, "zeroth_line"), "line1"],
				"line1": [Callable(self, "first_line"), "line2"],
				"line2": ["And it doesn't even fit me anymore!", "END"]
				}


func first_line() -> String:
	animplayer.play("Snake_Attack")
	animplayer.queue("Snake_Idle")
	return "Can't believe all I got was a damn shirt"


func zeroth_line() -> String:
	match Globals.player.curr_form:
		"knight":
			return "Hey knight"
		"bird":
			return "Hey messenger"
		"cow":
			return "Hey udderfiend"
		_:
			return "Hey unknown form"
