extends Node3D
class_name CursedItem
#TODO keep track of if it was taken when returning to a level

var item_name := "Bird Ring"
@export var item_type := "new form"
@export var form_name := "bird"

var bouncy_tween : Tween
var spinny_tween : Tween
@onready var cowbell = $Spinny/cowbell
@onready var feather = $Spinny/feather
@onready var spinny = $Spinny

func _ready():
	$PickupArea.body_entered.connect(_on_pickup_area_body_entered)
	$PickupArea.body_exited.connect(_on_pickup_area_body_exited)
	$PickupArea.collision_mask = 2
	$PickupArea.collision_layer = 0
	update_item()
	bouncy_tween = Globals.get_tween(bouncy_tween, self)
	bouncy_tween.set_loops().set_trans(Tween.TRANS_SINE)
	bouncy_tween.tween_property(spinny, "position:y", 1.05, 1.0)
	bouncy_tween.tween_property(spinny, "position:y", 0.70, 1.0)
	
	spinny_tween = Globals.get_tween(spinny_tween, self)
	spinny_tween.set_loops()
	spinny_tween.tween_property(spinny, "rotation:y", deg_to_rad(360), 4.0)
	spinny_tween.tween_property(spinny, "rotation:y", 0, 0.001)
	
	
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
