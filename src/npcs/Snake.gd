extends NPC

@onready var animplayer : AnimationPlayer = $Snake/AnimationPlayer


func _ready():
	$TalkArea.body_entered.connect(_on_talk_area_body_entered)
	$TalkArea.body_exited.connect(_on_talk_area_body_exited)
	npc_name = "Shirt Snake"
	animplayer.playback_default_blend_time = 0.1
	animplayer.play("Snake_Idle")
	dialogue = { "start": ["""You must be here to take on the tower right?
I reckon there has to be a REAL prize at the top of it. 
All I got was a curse, and this lousy t-shirt.
It doesn’t even fit me anymore!""", "line1", 1],
				"line1": [Callable(self, "zeroth_line"), "END", 0]
				}


func zeroth_line() -> String:
	#TODO anims play when 
	animplayer.play("Snake_Attack")
	animplayer.queue("Snake_Idle")
	var ret : String = ""
	match Globals.player.curr_form:
		"knight":
			ret += "Hey knight.\n"
		"bird":
			ret += "Hey eggbutt.\n"
		"cow":
			ret += "Hey milkbags.\n"
		_:
			ret += "Hey unknown form"
	ret += "Do you reckon they’ve got shirts up there without armholes?"
	return ret
