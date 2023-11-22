extends Level
#TODO don't spawn cursed item if already taken

@export var form := "bird"
@onready var cursed_item : CursedItem = $CursedItem


func __ready():
	cursed_item.form_name = form
	cursed_item.update_item()
	if Globals.level_state.has(name):
		if Globals.level_state[name]["cursed_item_taken"]:
			cursed_item.queue_free()
