extends NPC


@onready var animplayer : AnimationPlayer = $cow/AnimationPlayer
@export_range(1, 8) var cow_num := 1
@export var race : RaceManager


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
			npc_name = "Race Referee"
			dialogue = { "start": ["C’mon bud. Let’s chew some cud.", "END", 0]}
		5:
			npc_name = "Racing Cow"
#			animplayer.play("Run")
			dialogue = { "start": ["Well met, new brother. Or sister, on the account of our mutual lack of a tackle. The udder takes a while to get used to, but the perks are positively overflowing!", "line1", 1],
						 "line1": ["This part of the castle used to be a racetrack for horses. Me and the boys… girls have repurposed it for a race of sorts. If you can beat our best on a gentle trot across the grounds, maybe you’ll find a way out.", "line2", 1],
						 "line2": ["Beat me in a little race and I'll give you my power orb that I'm not using. See you on the track!", "line3", 0],
						 "line3": [start_race, "END", 0]}
		6:
			npc_name = "Figure 8 Racing Cow"
#			animplayer.play("Run")
			dialogue = {
				"start": ["Ready for a race? This one's not as simple as the last, you might have to use the \"Milk Jump\" technique! Just aim and shoot while you're in the air for a bit more jump.", "line1", 0],
				"line1": ["Beat me and I'll give you a power orb, you know the drill now.", "line2", 0],
				"line2": [start_race, "END", 0]
			}
		7:
			dialogue = {"start": ["Your udder's lookin pretty full there, try relieving some pressure! Just aim and shoot. Luckily we're cows so we're not responsible for spilled milk cleanup.", "END", 0]}
		8:
			dialogue = {"start": ["Psst check out this door behind me. If you can make the jump back to here I'll give you a power orb.", "END", 0]}
			
func start_race() -> String:
	if Globals.player.curr_form != "cow":
		return "Too bad I only race cows..."
	race.start_race()
	return "3... 2... 1... LET'S GO!"
