extends RigidBody3D


func _on_despawn_timer_timeout():
	queue_free()


func _on_player_col_timer_timeout():
	collision_mask += 2
