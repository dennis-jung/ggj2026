extends Node3D

@onready var camera_pivot : Node3D = $CameraPivot
@onready var camera : GameCamera = $CameraPivot/Camera3D
@onready var cameraTarget : Node3D = $CameraPivot/CameraTarget
@onready var guests_node : Node3D = $Guests

var npc_wolf_lady = preload("res://assets/Characters/wolf_lady.tscn")
var npc_lady_wolf = preload("res://assets/Characters/lady_wolf.tscn")
var npc_tuxed_man = preload("res://assets/Characters/tuxedo_man.tscn")

var selected_npc : Npc

var rotation_tween : Tween = null
var current_rotation_target : float = 0.0
var is_rotating : bool = false

func _ready() -> void:
	camera.look_at(cameraTarget.position)
	camera_pivot.rotation.y = deg_to_rad(45.0)
	current_rotation_target = camera_pivot.rotation.y
	add_guests()

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
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var result = camera.perform_raycast()
		if result:
			var hit_object = result.collider as Npc
			print("Clicked on: ", hit_object.name, " [", result.collider_id, "]")
			if (selected_npc):
				if (selected_npc.has_method("deselect")):
					selected_npc.deselect()
			selected_npc = hit_object
			if (hit_object.has_method("select")):
				hit_object.select()

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

func add_guests() -> void:
	for i in 100:
		var npc
		if (randf_range(-1.0, 1.0) >= 0.0):
			npc = npc_lady_wolf.instantiate()
		else:
			npc = npc_tuxed_man.instantiate()
		var x := randf_range(-9.0, 9.0)
		var z := randf_range(-9.0, 9.0)
		var rot := deg_to_rad(randf_range(0.0, 360.0))
		npc.name = "WolfLady_" + str(i)
		guests_node.add_child(npc)
		npc.rotation.y = rot
		npc.global_position = Vector3(x, 0.6, z)
		npc.add_to_group("npcs")
		
		
