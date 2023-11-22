extends MeshInstance3D

@onready var egg_area : Area3D = $EggArea
var button_tween : Tween
var is_pressed := false
var callback : Callable


func _ready():
	egg_area.body_entered.connect(_on_egg_entered)
	egg_area.collision_mask = 16

	
func _on_egg_entered(_body):
	if not is_pressed:
		print("button pressed")
		is_pressed = true
		button_tween = Globals.get_tween(button_tween, self)
		button_tween.tween_property(self, "position:x", position.x - 1.5, 0.5)
		button_tween.set_parallel().tween_property(mesh.material, "emission_energy_multiplier", 0.2, 0.5)
		if callback and callback.is_valid():
			callback.call()
