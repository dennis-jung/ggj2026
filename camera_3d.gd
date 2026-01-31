extends Camera3D
class_name GameCamera

func perform_raycast() -> Dictionary:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 1000.0 # How far the ray reaches
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * ray_length
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	return space_state.intersect_ray(query)
