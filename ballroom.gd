extends Node3D
class_name Ballroom

@export var transparency_zone : float = 15.0

@onready var wallEast : MeshInstance3D = $Wall00
@onready var wallNorth : MeshInstance3D = $Wall01
@onready var wallWest : MeshInstance3D = $Wall02
@onready var wallSouth : MeshInstance3D = $Wall03

func _ready() -> void:
	wallEast.show()
	wallNorth.show()
	wallWest.show()
	wallSouth.show()

func set_wall_visibility(rotation_y : float) -> void:
	var clamped_rotation_deg : int  = int(rad_to_deg(rotation_y)) % 360
	if (clamped_rotation_deg < 0):
		clamped_rotation_deg = clamped_rotation_deg + 360
		
	# south wall
	if (clamped_rotation_deg >= 135.0 - transparency_zone and clamped_rotation_deg <= 225.0 + transparency_zone):
		wallSouth.transparency = 0.0
		#print("transparency = ", 0.0, " @ ", clamped_rotation_deg, " deg")
	elif (clamped_rotation_deg <= 45.0 + transparency_zone or clamped_rotation_deg >= 315.0 - transparency_zone):
		wallSouth.transparency = 1.0
		#print("transparency = ", 1.0, " @ ", clamped_rotation_deg, " deg")
	elif (clamped_rotation_deg < 135.0):
		wallSouth.transparency = calculate_transparency(clamped_rotation_deg, 135.0 - transparency_zone, 45.0 + transparency_zone)
		print("south wall transparency: ", wallSouth.transparency)
	else:
		wallSouth.transparency = calculate_transparency(clamped_rotation_deg, 225.0 + transparency_zone, 315.0 - transparency_zone)
		print("south wall transparency: ", wallSouth.transparency)
	
	# east wall
	if (clamped_rotation_deg >= 225.0 - transparency_zone and clamped_rotation_deg <= 315.0 + transparency_zone):
		wallEast.transparency = 0.0
		#print("transparency = ", 0.0, " @ ", clamped_rotation_deg, " deg")
	elif (clamped_rotation_deg <= 135.0 + transparency_zone):
		wallEast.transparency = 1.0
		#print("transparency = ", 1.0, " @ ", clamped_rotation_deg, " deg")
	else:
		wallEast.transparency = calculate_transparency(clamped_rotation_deg, 225.0 - transparency_zone, 135 + transparency_zone)
		print("east wall transparency: ", wallEast.transparency)

	# north wall
	if (clamped_rotation_deg >= 135.0 - transparency_zone and clamped_rotation_deg <= 225.0 + transparency_zone):
		wallNorth.transparency = 1.0
		#print("transparency = ", 0.0, " @ ", clamped_rotation_deg, " deg")
	elif (clamped_rotation_deg <= 45.0 + transparency_zone or clamped_rotation_deg >= 315.0 - transparency_zone):
		wallNorth.transparency = 0.0
		#print("transparency = ", 1.0, " @ ", clamped_rotation_deg, " deg")
	elif (clamped_rotation_deg < 135.0):
		wallNorth.transparency = calculate_transparency(clamped_rotation_deg, 45.0 + transparency_zone, 135.0 - transparency_zone)
		print("north wall transparency: ", wallNorth.transparency)
	else:
		wallNorth.transparency = calculate_transparency(clamped_rotation_deg, 315.0 - transparency_zone, 225.0 + transparency_zone)
		print("north wall transparency: ", wallNorth.transparency)
	
	# west wall
	if (clamped_rotation_deg >= 225.0 - transparency_zone and clamped_rotation_deg <= 315.0 + transparency_zone):
		wallWest.transparency = 1.0
		#print("transparency = ", 0.0, " @ ", clamped_rotation_deg, " deg")
	elif (clamped_rotation_deg <= 135.0 + transparency_zone):
		wallWest.transparency = 0.0
		#print("transparency = ", 1.0, " @ ", clamped_rotation_deg, " deg")
	else:
		wallWest.transparency = calculate_transparency(clamped_rotation_deg, 135 + transparency_zone, 225.0 - transparency_zone)
		print("west wall transparency: ", wallWest.transparency)


func calculate_transparency(current : float, from : float, to : float) -> float:
	var delta : float = abs(to - from)
	var ratio : float = abs ((current - from) / delta)
	return ratio
	
