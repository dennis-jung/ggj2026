extends StaticBody3D
class_name Npc

@onready var meshFront : MeshInstance3D = $MeshInstanceFront
@onready var maskAttachmentPoint: Marker3D = $MaskPosition

var mask: Mask

func _ready() -> void:
	if meshFront.material_overlay:
		meshFront.material_overlay = meshFront.material_overlay.duplicate()
	check_mask_as_child()

func check_mask_as_child() -> void:
	for child in get_children():
		if child is Mask:
			mask = child as Mask
			#print("reparenting ", mask.name)
			mask.reparent(maskAttachmentPoint)
			mask.position = Vector3.ZERO

func set_mask(newMask: Mask) -> void:
	#print("NPC ", name, ", set_mask(", mask.name,")")
	var maskPosition = get_node_or_null("MaskPosition")
	if maskPosition:
		for child in maskPosition.get_children():
			child.queue_free()
		maskPosition.add_child(newMask)
		mask = newMask
		print(mask.visible)
		print(mask.position)

func select():
	var material = meshFront.material_overlay as StandardMaterial3D
	material.grow_amount = 0.02

func deselect():
	var material = meshFront.material_overlay as StandardMaterial3D
	material.grow_amount = 0.0

func toggle_select():
	if is_selected():
		deselect()
	else:
		select()

func is_selected() -> bool:
	var material = meshFront.material_overlay as StandardMaterial3D
	return material.grow_amount != 0.0

func get_mask_details() -> Dictionary:
	var result: Dictionary = {}
	result.set("type", mask.name)
	result.set("material", mask.material.resource_name)
	return result
