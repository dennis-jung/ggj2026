extends Node3D

@onready var ballroom : Ballroom = $Ballroom
@onready var camera_pivot : Node3D = $CameraPivot
@onready var camera : Camera3D = $CameraPivot/Camera3D
@onready var cameraTarget : Node3D = $CameraPivot/CameraTarget

var rotation_tween : Tween = null
var current_rotation_target : float = 0.0
var is_rotating : bool = false

func _ready() -> void:
	camera.look_at(cameraTarget.position)
	camera_pivot.rotation.y = deg_to_rad(45.0)
	current_rotation_target = camera_pivot.rotation.y

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("rotate_left"):
		current_rotation_target = current_rotation_target + deg_to_rad(90.0)
		rotate_camera()
	if event.is_action_pressed("rotate_right"):
		current_rotation_target = current_rotation_target - deg_to_rad(90.0)
		rotate_camera()
	if event.is_action("zoom_in"):
		camera.translate_object_local(Vector3(0.0, 0.0, -1.0))
	if event.is_action("zoom_out"):
		camera.translate_object_local(Vector3(0.0, 0.0, +1.0))

func _process(_delta: float) -> void:
	ballroom.set_wall_visibility(camera_pivot.rotation.y)

func rotate_camera() -> void:
	is_rotating = true
	if rotation_tween:
		rotation_tween.kill()
	rotation_tween = create_tween()
	rotation_tween.set_trans(Tween.TRANS_CUBIC)
	var target_rotation = Vector3(0.0, current_rotation_target, 0.0)
	rotation_tween.tween_property(camera_pivot, "rotation", target_rotation, 1.0)
	rotation_tween.tween_callback(end_rotation)

func end_rotation() -> void:
	is_rotating = false
