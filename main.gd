extends Node3D

@export var level: Level

@onready var camera_pivot : Node3D = $CameraPivot
@onready var camera : GameCamera = $CameraPivot/Camera3D
@onready var cameraTarget : Node3D = $CameraPivot/CameraTarget
@onready var guests : Node3D = $Guests
@onready var ui: UICanvas = $UI

var rotation_tween : Tween = null
var current_rotation_target : float = 0.0

var selected_npcs: Array[Npc] = []

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
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		handle_npc_click()

func rotate_camera() -> void:
	if rotation_tween:
		rotation_tween.kill()
	rotation_tween = create_tween()
	rotation_tween.set_trans(Tween.TRANS_CUBIC)
	var target_rotation = Vector3(0.0, current_rotation_target, 0.0)
	rotation_tween.tween_property(camera_pivot, "rotation", target_rotation, 1.0)
	
func handle_npc_click() -> void:
	var result = camera.perform_raycast()
	if result:
		var npc = result.collider as Npc
		if npc:
			if selected_npcs.has(npc):
				var index = selected_npcs.find(npc)
				selected_npcs.remove_at(index)
				npc.deselect()
			else:
				selected_npcs.append(npc)
				npc.select()
			if selected_npcs.size() > 0:
				if level:
					var clue = level.get_clue(selected_npcs)
					match clue.result:
						"nothing":
							ui.show_bottom_text_box(clue.text)
						"single":
							ui.show_bottom_text_box(clue.text)
						"mismatch":
							ui.show_bottom_text_box(clue.text)
							deselect_all()
						"exhausted":
							ui.show_bottom_text_box(clue.text)
						"clue":
							ui.show_bottom_text_box(clue.text)							
	else:
		print("Clicked away")
		deselect_all()

func deselect_all() -> void:
	get_tree().call_group("npcs", "deselect")
	selected_npcs.clear()
