extends Node3D

@onready var camera_pivot : Node3D = $CameraPivot
@onready var camera : GameCamera = $CameraPivot/Camera3D
@onready var cameraTarget : Node3D = $CameraPivot/CameraTarget
@onready var guests : Node3D = $Guests
@onready var ui: UICanvas = $UI

var npc_lady_wolf = preload("res://assets/Characters/npc_woman.tscn")
var npc_tuxed_man = preload("res://assets/Characters/npc_man.tscn")
var mask_brown = preload("res://assets/characters/masks/mask_brown.tscn")
var mask_coyote = preload("res://assets/characters/masks/mask_coyote.tscn")
var mask_wolf = preload("res://assets/characters/masks/mask_wolf.tscn")
var mats_brown = [
	preload("res://assets/characters/masks/brown/mask_brown_blue_material.tres"),
	preload("res://assets/characters/masks/brown/mask_brown_green_material.tres"),
	preload("res://assets/characters/masks/brown/mask_brown_yellow_material.tres")]
var mats_coyote = [
	preload("res://assets/characters/masks/coyote/coyote_blue_material.tres"),
	preload("res://assets/characters/masks/coyote/coyote_green_material.tres"),
	preload("res://assets/characters/masks/coyote/coyote_red_material.tres")
]
var mats_wolf = [
	preload("res://assets/characters/masks/wolf/wolf_blue_material.tres"),
	preload("res://assets/characters/masks/wolf/wolf_red_material.tres"),
	preload("res://assets/characters/masks/wolf/wolf_yellow_material.tres")
]

var rotation_tween : Tween = null
var current_rotation_target : float = 0.0
var is_rotating : bool = false

var selected_npcs: Array[Npc] = []

func _ready() -> void:
	camera.look_at(cameraTarget.position)
	camera_pivot.rotation.y = deg_to_rad(45.0)
	current_rotation_target = camera_pivot.rotation.y
	for child in guests.get_children():
		child.add_to_group("npcs")
	#add_guests()

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
				if selected_npcs.has(npc):
					var index = selected_npcs.find(npc)
					selected_npcs.remove_at(index)
					npc.deselect()
				else:
					var npc_mask = npc.get_mask_details()
					match selected_npcs.size():
						0:
								npc.select()
								selected_npcs.append(npc)
								var text = "You chose " + npc.name
								text = text + " (" + npc_mask.type + ", " + npc_mask.material + ")"
								ui.show_bottom_text_box(text)
						1:
							var selected_npc = selected_npcs[0]
							var selected_npc_mask = selected_npc.get_mask_details()
							if npc_mask == selected_npc_mask:
								npc.select()
								selected_npcs.append(npc)
								var text = "You chose " + npc.name
								text = text + " (" + npc_mask.type + ", " + npc_mask.material + ")\n"
								text = text + "Yay! " + npc.name + " matched with " + selected_npc.name
								text = text + " (" + selected_npc_mask.type + ", " + selected_npc_mask.material + ")\n"
								ui.show_bottom_text_box(text)
							else:
								var text = "You chose " + npc.name
								text = text + " (" + npc_mask.type + ", " + npc_mask.material + ")\n"
								text = text + "Oh no! " + npc.name + " did not match with " + selected_npc.name
								text = text + " (" + selected_npc_mask.type + ", " + selected_npc_mask.material + ")\n"
								ui.show_bottom_text_box(text)
		else:
			print("Clicked away")
			get_tree().call_group("npcs", "deselect")
			selected_npcs.clear()
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
		var npc: Npc
		if (randf_range(-1.0, 1.0) >= 0.0):
			npc = npc_lady_wolf.instantiate()
		else:
			npc = npc_tuxed_man.instantiate()
		var mask: Mask
		var randMask = randi_range(0, 2)
		var randColor = randi_range(0, 2)
		if randMask == 0:
			mask = mask_brown.instantiate()
			mask.material = mats_brown[randColor]
		elif randMask == 1:
			mask = mask_coyote.instantiate()
			mask.material = mats_coyote[randColor]
		elif randMask == 2:
			mask = mask_wolf.instantiate()
			mask.material = mats_wolf[randColor]
		var x := randf_range(-8.5, 8.5)
		var z := randf_range(-8.5, 8.5)
		var rot := deg_to_rad(randf_range(0.0, 360.0))
		npc.name = npc.name + "_" + str(i)
		npc.set_mask(mask)
		guests.add_child(npc)
		npc.rotation.y = rot
		npc.global_position = Vector3(x, 0.6, z)
		npc.add_to_group("npcs")
		
		
