extends Level

@export var form := "bird"
@onready var cursed_item : CursedItem = $CursedItem


func __ready():
	cursed_item.form_name = form
	cursed_item.update_item()
