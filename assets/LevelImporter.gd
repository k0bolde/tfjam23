@tool
extends EditorScenePostImport
#imports meshes whose names end in "-ab" as animatible bodies

var root

func _post_import(scene):
	root = scene
	iterate(scene)
	
	return scene
	
func iterate(node):
	if node is MeshInstance3D and node.name.ends_with("-ab"):
		var animbody := AnimatableBody3D.new()
		animbody.name = "%sAnimatableBody3D" % node.name.trim_suffix("-ab")
		animbody.position = node.position
		#weird jitter when it syncs
		animbody.sync_to_physics = false
		var parent = node.get_parent()
		parent.add_child(animbody)
		animbody.set_owner(root)
		parent.remove_child(node)
		animbody.add_child(node)
		node.position = Vector3.ZERO
		
		var shape : ConvexPolygonShape3D = node.mesh.create_convex_shape(true, false)
#		shape.margin = 0.001
		var col := CollisionShape3D.new()
		col.name = "%sCollision" % animbody.name
		col.shape = shape
		animbody.add_child(col)
		col.set_owner(root)
	
	if node:
		for child in node.get_children():
			iterate(child)
