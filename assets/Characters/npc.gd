extends StaticBody3D
class_name Npc

@onready var meshFront : MeshInstance3D = $MeshInstanceFront

func _ready() -> void:
	if meshFront.material_overlay:
		meshFront.material_overlay = meshFront.material_overlay.duplicate()

func select():
	var material = meshFront.material_overlay as StandardMaterial3D
	material.grow_amount = 0.02

func deselect():
	var material = meshFront.material_overlay as StandardMaterial3D
	material.grow_amount = 0.0
