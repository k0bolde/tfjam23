extends NPC


@onready var animplayer : AnimationPlayer = $cow/AnimationPlayer
@export_range(1, 5) var cow_num := 1

func _ready():
	$TalkArea.body_entered.connect(_on_talk_area_body_entered)
	$TalkArea.body_exited.connect(_on_talk_area_body_exited)
	
	npc_name = "Cow #%d" % cow_num
	match cow_num:
		1:
			dialogue = { "start": ["Hey bro. Have you still got thumbs? I’m feeling pretty full in the ol’ milkbag and I’m fresh out of options here.", "END", 0]}
		2:
			dialogue = { "start": ["Got a real odd feeling about the other cows. Such a weird moooood.", "END", 0]}
		3:
			dialogue = { "start": ["Cow? How? Well now….", "END", 0]}
		4:
			dialogue = { "start": ["C’mon bud. Let’s chew some cud.", "END", 0]}
		5:
			npc_name = "Racing Cow"
			animplayer.play("Run")
			dialogue = { "start": ["Well met, new brother. Or sister, on the account of our mutual lack of a tackle. The udder takes a while to get used to, but the perks are positively overflowing!", "line1", 1],
						 "line1": ["This part of the castle used to be a racetrack for horses. Me and the boys… girls have repurposed it for a race of sorts. If you can beat our best on a gentle trot across the grounds, maybe you’ll find a way out.", "line2", 1],
						 "line2": ["See you on the track!", "line3", 0],
						 "line3": ["3... 2... 1... LET'S GO!", "END", 0]}
			
