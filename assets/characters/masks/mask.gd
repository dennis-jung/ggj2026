extends StaticBody3D
class_name Mask

@export var material: StandardMaterial3D

@onready var mesh: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	if material:
		print("Mask ready, setting material ", material.resource_name)
		mesh.set_surface_override_material(0, material)

func set_material(new_material: StandardMaterial3D) -> void:
	material = new_material
	mesh.set_surface_override_material(0, material)
	
