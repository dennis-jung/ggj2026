extends Camera3D
class_name GameCamera

@export_group("Zoom Limits")
@export var min_zoom_dist: float = 4.0
@export var max_zoom_dist: float = 12.0
@export var zoom_step: float = 0.15 # How much each click/press zooms
@export var smoothness: float = 0.1 # Lower is smoother
@export var height_curve: Curve

@export_group("Target Shifting")
@export var max_target_offset: float = 3.0 # How far the look-at shifts


# Internal states
var target_zoom_ratio: float = 0.0 # 0.0 (Far) to 1.0 (Near)
var current_zoom_ratio: float = 0.0
var room_center: Vector3 = Vector3.ZERO

func _input(event: InputEvent):
	# Check for our custom Input Actions
	if event.is_action_pressed("zoom_in"):
		target_zoom_ratio = clamp(target_zoom_ratio + zoom_step, 0.0, 1.0)
	elif event.is_action_pressed("zoom_out"):
		target_zoom_ratio = clamp(target_zoom_ratio - zoom_step, 0.0, 1.0)

func _process(_delta: float):
	# 1. Smoothly interpolate the current ratio toward the target
	current_zoom_ratio = lerp(current_zoom_ratio, target_zoom_ratio, smoothness)
	
	# 2. Calculate the Camera Position (Moving along local Z)
	# We use the parent (Pivot) to maintain the 45-degree angle
	var zoom_dist = lerp(max_zoom_dist, min_zoom_dist, current_zoom_ratio)
	transform.origin.z = zoom_dist
	
	var height_factor = height_curve.sample(current_zoom_ratio)
	transform.origin.y = lerp(12.0, 5.0, height_factor) # Adjust 8 and 2 for tilt

	# 3. Calculate the Dynamic Look-At Target
	# As we zoom in, we shift the target toward the camera's direction
	# so that the 'front' floor stays visible.
	var cam_parent = get_parent() as Node3D
	if cam_parent:
		# Get the direction the camera is coming from
		var flattened_cam_dir = (global_position - room_center)
		flattened_cam_dir.y = 0
		flattened_cam_dir = flattened_cam_dir.normalized()
		
		# Shift target towards the camera's side of the room as we zoom in
		var target_offset = flattened_cam_dir * (current_zoom_ratio * max_target_offset)
		var dynamic_look_at = room_center #+ target_offset
		
		look_at(dynamic_look_at)

func perform_raycast() -> Dictionary:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 1000.0 # How far the ray reaches
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * ray_length
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	return space_state.intersect_ray(query)
