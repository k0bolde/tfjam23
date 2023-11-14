extends MeshInstance3D
#TODO can get head stuck on bottom of block and it behaves strangely, but does respawn you

@export var fall_y := 35.0
@export var fall_speed := 4.0
@export var wait_time := 0.75

@onready var initial_y = position.y
var is_falling := false
var is_raising := false

	
var t : Tween
func player_touched(_player):
	t = Globals.get_tween(t, self)
	t.tween_property(self, "is_falling", true, wait_time)
	is_raising = false
	
	
func _physics_process(delta):
	if is_falling:
		if position.y <= fall_y:
			is_falling = false
			is_raising = true
			return
		position.y -= fall_speed * delta
	elif is_raising:
		if position.y >= initial_y:
			is_raising = false
			return
		position.y += fall_speed * delta * 2.0
			
			
