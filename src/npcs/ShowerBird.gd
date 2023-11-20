extends NPC

@onready var animplayer : AnimationPlayer = $bird/AnimationPlayer

func _ready():
	$TalkArea.body_entered.connect(_on_talk_area_body_entered)
	$TalkArea.body_exited.connect(_on_talk_area_body_exited)
	npc_name = "Wizard Bird"
	dialogue = { "start": ["Prithee. Traveller, stay a while and listen to thee.", "line1", 1],
				"line1": ["You’ve been cursed to look just like me. Bwaark!", "line2", 1],
				"line2": ["Mmm… My scroll of identify told me that it was a ring of multiclass.", "line3", 1],
				"line3": ["I suppose it was correct. We’re both level one birds now. But where did my wizard powers go?", "line4", 1],
				"line4": ["Laying eggs sucks ass.", "line5", 1],
				"line5": ["Remove curse? I can’t cast that without fingers!", "END", 0],
				
				}
