extends RigidBody3D

@onready var decal : Decal = $Decal


func _integrate_forces(state):
    if state.get_contact_count() > 0:
        var normal = state.get_contact_local_normal(0)
#        decal.rotation = normal
        #rotate the decal to the surface
        decal.transform.basis.y = normal
        decal.transform.basis.x = -decal.transform.basis.z.cross(normal)
        decal.transform.basis = decal.transform.basis.orthonormalized()
        decal.visible = true
        decal.reparent(state.get_contact_collider_object(0))
        queue_free()
        
