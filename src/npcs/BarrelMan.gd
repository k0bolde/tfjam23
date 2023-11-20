extends NPC

func _ready():
	$TalkArea.body_entered.connect(_on_talk_area_body_entered)
	$TalkArea.body_exited.connect(_on_talk_area_body_exited)
	npc_name = "Barrelman"
	dialogue = { "start": ["I used to be a fine creature like you. A special vintage of sorts. Now I’m stuck as what I am. In this barrel too.", "line1", 1],
				"line1": ["I’m not sour about it. I’ve just gotta brew up a way to get out of this mess.", "END", 0],
				}
