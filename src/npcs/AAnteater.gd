extends NPC


func _ready():
	$TalkArea.body_entered.connect(_on_talk_area_body_entered)
	$TalkArea.body_exited.connect(_on_talk_area_body_exited)
	npc_name = "Adventurous Anteater"
	dialogue = { "start": ["Life’s a minigame when you’ve got a tongue like me. Flick and lick your way through those ant nests over there. I’ve heard you can get enough of a grip to FLING your way across this part of the castle!", "line1", 1],
				 "line1": ["Lickety split! So many things to slurp!", "END", 0]
	}
