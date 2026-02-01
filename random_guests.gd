extends Node3D

@export var guests: Node3D

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

func add_guests(guest_count: int) -> void:
	for i in guest_count:
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
