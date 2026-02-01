extends Node3D

@export var transparency_curve: Curve
@export var room_center: Vector3 = Vector3.ZERO

func _ready() -> void:
		for child in get_children():
			if child.has_method("show"):
				child.show()

func _process(_delta: float) -> void:
	var camera = get_viewport().get_camera_3d()
	if not camera: 
		return

	var cam_dir = (camera.global_position - room_center)
	cam_dir.y = 0
	cam_dir = cam_dir.normalized()

	for child in get_children():
		if child is MeshInstance3D:
			if not child.name.begins_with("Wall"):
				continue
			var wall_dir = (child.global_position - room_center)
			wall_dir.y = 0
			wall_dir = wall_dir.normalized()
			var dot = wall_dir.dot(cam_dir)
			var alpha = transparency_curve.sample(clamp(dot, 0.0, 1.0))
			update_wall_transparency(child, alpha)

func update_wall_transparency(mesh: MeshInstance3D, alpha: float) -> void:
	if not is_equal_approx(mesh.transparency, alpha):
		mesh.transparency = 1.0 - alpha
