extends Node3D

@onready var ballroom : Ballroom = $Ballroom
@onready var camera_pivot : Node3D = $CameraPivot
@onready var camera : Camera3D = $CameraPivot/Camera3D

var rotation_tween : Tween = null
var current_rotation_target : float = 0.0

func _ready() -> void:
	camera.look_at(Vector3.ZERO)
	camera_pivot.rotation.y = deg_to_rad(45.0)
	current_rotation_target = camera_pivot.rotation.y

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		current_rotation_target = current_rotation_target + deg_to_rad(90.0)
		rotate_camera()
	if event.is_action_pressed("ui_right"):
		current_rotation_target = current_rotation_target - deg_to_rad(90.0)
		rotate_camera()

func _process(delta: float) -> void:
	ballroom.set_wall_visibility(camera_pivot.rotation.y)

func rotate_camera() -> void:
	if rotation_tween:
		rotation_tween.kill()
	rotation_tween = create_tween()
	var target_rotation = Vector3(0.0, current_rotation_target, 0.0)
	rotation_tween.tween_property(camera_pivot, "rotation", target_rotation, 1.0)
	
