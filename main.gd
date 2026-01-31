extends Node3D

@onready var camera_pivot : Node3D = $CameraPivot
@onready var camera : GameCamera = $CameraPivot/Camera3D
@onready var cameraTarget : Node3D = $CameraPivot/CameraTarget
@onready var guests_node : Node3D = $Guests
@onready var ui: UICanvas = $UI

var npc_wolf_lady = preload("res://assets/Characters/wolf_lady/wolf_lady.tscn")
var npc_lady_wolf = preload("res://assets/Characters/lady_wolf/lady_wolf.tscn")
var npc_tuxed_man = preload("res://assets/Characters/tuxedo_man/tuxedo_man.tscn")

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
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var result = camera.perform_raycast()
		if result:
			var npc = result.collider as Npc
			if npc:
				print("Clicked on: ", npc.name, " [", result.collider_id, "]")
				ui.show_bottom_text_box("You clicked on NPC " + npc.name)
				npc.toggle_select()
		else:
			print("Clicked away")
			get_tree().call_group("npcs", "deselect")
			ui.hide_bottom_text_box()

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
		var x := randf_range(-8.5, 8.5)
		var z := randf_range(-8.5, 8.5)
		var rot := deg_to_rad(randf_range(0.0, 360.0))
		npc.name = npc.name + "_" + str(i)
		guests_node.add_child(npc)
		npc.rotation.y = rot
		npc.global_position = Vector3(x, 0.6, z)
		npc.add_to_group("npcs")
		
		
