extends Node3D

@onready var ballroom : Ballroom = $Ballroom
@onready var camera : Camera3D = $Camera3D
var view_point = 0

func _ready() -> void:
	set_viewpoint()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		view_point = view_point + 1
		if view_point > 3:
			view_point = 0
		set_viewpoint()
	if event.is_action_pressed("ui_right"):
		view_point = view_point - 1
		if view_point < 0:
			view_point = 3
		set_viewpoint()

func set_viewpoint() -> void:
	match view_point:
		0:
			ballroom.set_wall_visibility("southeast")
			camera.position = Vector3(25.0, 25.0, 25.0)
			camera.look_at(Vector3.ZERO)
		1:
			ballroom.set_wall_visibility("northeast")
			camera.position = Vector3(25.0, 25.0, -25.0)
			camera.look_at(Vector3.ZERO)
		2:
			ballroom.set_wall_visibility("northwest")
			camera.position = Vector3(-25.0, 25.0, -25.0)
			camera.look_at(Vector3.ZERO)
		3:
			ballroom.set_wall_visibility("southwest")
			camera.position = Vector3(-25.0, 25.0, 25.0)
			camera.look_at(Vector3.ZERO)
	print(view_point, camera.position)
