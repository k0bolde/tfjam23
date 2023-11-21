extends Node3D
class_name CursedItem
#TODO keep track of if it was taken when returning to a level

var item_name := "Bird Ring"
@export var item_type := "new form"
@export var form_name := "bird"

var spinny_tween : Tween
@onready var cowbell = $Spinny/cowbell
@onready var feather = $Spinny/feather


func _ready():
	$PickupArea.body_entered.connect(_on_pickup_area_body_entered)
	$PickupArea.body_exited.connect(_on_pickup_area_body_exited)
	$PickupArea.collision_mask = 2
	$PickupArea.collision_layer = 0
	update_item()
	
	
func update_item():
	match form_name:
		"bird":
			feather.visible = true
			cowbell.visible = false
			item_name = "Feather"
		"cow":
			cowbell.visible = true
			feather.visible = false
			item_name = "Cow Bell"
	
	
func _on_pickup_area_body_entered(body):
	body.pickup_area_entered(form_pickup)
	
	
func _on_pickup_area_body_exited(body):
	#TODO change to more specific hide func
	body.hide_dialog()
	body.pickup_callable = Callable()


func form_pickup() -> Dictionary:
	var p := {"type": item_type, "item_name": item_name, "form_name": form_name}
	queue_free()
	return p
