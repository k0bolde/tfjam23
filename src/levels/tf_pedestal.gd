extends Level

@export var form := "bird"
@onready var cursed_item : CursedItem = $CursedItem


func __ready():
	cursed_item.form_name = form
	cursed_item.update_item()
	if Globals.level_state.has(form) and Globals.level_state[form].has("cursed_item_taken"):
		if Globals.level_state[form]["cursed_item_taken"]:
			cursed_item.queue_free()
