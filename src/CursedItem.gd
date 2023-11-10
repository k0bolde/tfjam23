extends Node3D

@export var item_name := "Bird Ring"
@export var item_type := "new form"
@export var form_name := "bird"


func _ready():
	$PickupArea.body_entered.connect(_on_pickup_area_body_entered)
	$PickupArea.body_exited.connect(_on_pickup_area_body_exited)
	$PickupArea.collision_mask = 2
	$PickupArea.collision_layer = 0
	
	
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
