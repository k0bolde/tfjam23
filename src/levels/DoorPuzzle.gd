extends Node3D

var LWeight : Node3D
var RWeight : Node3D
var door : Node3D
@onready var LArea : Area3D = $LTowerArea
@onready var RArea : Area3D = $RTowerArea
var is_l_cut := false
var is_r_cut := false

func _ready():
	door = get_parent_node_3d().get_node("Cylinder_003")
	LWeight = get_parent_node_3d().get_node("Cube_001")
	RWeight = get_parent_node_3d().get_node("Cube")
	LArea.body_entered.connect(_on_body_entered.bind("LArea"))
	RArea.body_entered.connect(_on_body_entered.bind("RArea"))
	LArea.body_exited.connect(_on_body_exited)
	RArea.body_exited.connect(_on_body_exited)
	if Globals.level_state.has(get_parent().name):
		if Globals.level_state[get_parent().name]["is_l_cut"]:
			cut("L")
		if Globals.level_state[get_parent().name]["is_r_cut"]:
			cut("R")
	else:
		Globals.level_state[get_parent().name] = {"is_l_cut": false, "is_r_cut": false}


func _on_body_entered(body, area_name):
	#show popup to player and send callable to correct cut, if not already cut
	if area_name == "LArea" and not is_l_cut:
		body.interact_area_entered("Cut Rope (E)", cut.bind("L"))
	elif area_name == "RArea" and not is_r_cut:
		body.interact_area_entered("Cut Rope (E)", cut.bind("R"))
	
	
func _on_body_exited(body):
	#hide prompt on player
	body.interact_area_exited()


var drop_l_tween : Tween
var drop_r_tween : Tween
var raise_tween : Tween
func cut(dir):
	var weight : Node3D
	if dir == "R" and not is_r_cut:
		is_r_cut = true
		weight = RWeight
		Globals.level_state[get_parent().name]["is_r_cut"] = true
		drop_r_tween = Globals.get_tween(drop_r_tween, self)
		drop_r_tween.set_trans(Tween.TRANS_BOUNCE)
		drop_r_tween.tween_property(weight, "position:y", 2.5, 2.0)
	elif dir == "L" and not is_l_cut:
		is_l_cut = true
		Globals.level_state[get_parent().name]["is_l_cut"] = true
		weight = LWeight
		drop_l_tween = Globals.get_tween(drop_l_tween, self)
		drop_l_tween.set_trans(Tween.TRANS_BOUNCE)
		drop_l_tween.tween_property(weight, "position:y", 2.5, 2.0)
	else:
		return
	
	raise_tween = Globals.get_tween(raise_tween, self)
	if is_l_cut and is_r_cut:
		raise_tween.tween_property(door, "position:y", 4.0, 2.0)
	elif is_l_cut or is_r_cut:
		raise_tween.tween_property(door, "position:y", 2.1, 2.0)
		
