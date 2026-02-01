extends Node3D

@export var level: Level

@onready var camera_pivot : Node3D = $CameraPivot
@onready var camera : GameCamera = $CameraPivot/Camera3D
@onready var cameraTarget : Node3D = $CameraPivot/CameraTarget
@onready var ui: UICanvas = $UI

var rotation_tween : Tween = null
var current_rotation_target : float = 0.0

var selected_npcs: Array[Npc] = []

func _ready() -> void:
	camera.look_at(cameraTarget.position)
	camera_pivot.rotation.y = deg_to_rad(45.0)
	current_rotation_target = camera_pivot.rotation.y

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
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
					var clue: Dictionary[String, String] = level.get_clue(selected_npcs)
					var maskTexture: Texture2D = selected_npcs[0].mask.material.albedo_texture
					match clue.result:
						"nothing":
							ui.show_bottom_text_box(clue.text, maskTexture)
						"single":
							ui.show_bottom_text_box(clue.text, maskTexture)
						"mismatch":
							ui.show_bottom_text_box(clue.text, maskTexture)
							deselect_all()
						"exhausted":
							ui.show_bottom_text_box(clue.text, maskTexture)
						"clue":
							ui.show_bottom_text_box(clue.text, maskTexture)
						"last_clue":
							ui.show_bottom_text_box(clue.text, maskTexture)
							var mask_data = npc.get_mask_details()
							var npcs_with_mask = get_tree().get_nodes_in_group(mask_data.type + "__" + mask_data.material)
							for item in npcs_with_mask:
								var mask_npc = item as Npc
								mask_npc.exclude_from_suspects()
							deselect_all()
	else:
		#print("Clicked away")
		ui.hide_bottom_text_box()
		deselect_all()

func deselect_all() -> void:
	get_tree().call_group("npcs", "deselect")
	selected_npcs.clear()
