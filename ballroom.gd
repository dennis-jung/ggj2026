extends Node3D
class_name Ballroom

@onready var wallEast : MeshInstance3D = $Wall00
@onready var wallNorth : MeshInstance3D = $Wall01
@onready var wallWest : MeshInstance3D = $Wall02
@onready var wallSouth : MeshInstance3D = $Wall03

func set_wall_visibility(rotation_y : float) -> void:
	print(rotation_y)
	var clamped_rotation_deg : int  = int(rad_to_deg(rotation_y)) % 360
	if (clamped_rotation_deg < 0):
		clamped_rotation_deg = clamped_rotation_deg + 360
	if (clamped_rotation_deg > 0 and clamped_rotation_deg <= 90):
		print("SE", clamped_rotation_deg)
		wallSouth.hide()
		wallEast.hide()
		wallNorth.show()
		wallWest.show()
	elif (clamped_rotation_deg > 90 and clamped_rotation_deg <= 180):
		print("NE", clamped_rotation_deg)
		wallSouth.show()
		wallEast.hide()
		wallNorth.hide()
		wallWest.show()
	elif (clamped_rotation_deg > 180 and clamped_rotation_deg <= 270):
		print("NW", clamped_rotation_deg)
		wallSouth.show()
		wallEast.show()
		wallNorth.hide()
		wallWest.hide()
	elif (clamped_rotation_deg > 270 and clamped_rotation_deg <= 360):
		print("SW", clamped_rotation_deg)
		wallSouth.hide()
		wallEast.show()
		wallNorth.show()
		wallWest.hide()
