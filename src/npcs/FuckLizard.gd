extends NPC


func _ready():
	$TalkArea.body_entered.connect(_on_talk_area_body_entered)
	$TalkArea.body_exited.connect(_on_talk_area_body_exited)
	npc_name = "Gigantic Fuckoff Lizard"
	dialogue = { "start": ["Hmm? Oh. I thought you were a bug.", "END", 0]}
