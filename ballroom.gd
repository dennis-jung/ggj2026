extends Node3D
class_name Ballroom

@onready var wallEast : MeshInstance3D = $Wall00
@onready var wallNorth : MeshInstance3D = $Wall01
@onready var wallWest : MeshInstance3D = $Wall02
@onready var wallSouth : MeshInstance3D = $Wall03

func set_wall_visibility(direction):
	match direction:
		"southeast":
			wallSouth.hide()
			wallEast.hide()
			wallNorth.show()
			wallWest.show()
		"northeast":
			wallSouth.show()
			wallEast.hide()
			wallNorth.hide()
			wallWest.show()
		"northwest":
			wallSouth.show()
			wallEast.show()
			wallNorth.hide()
			wallWest.hide()
		"southwest":
			wallSouth.hide()
			wallEast.show()
			wallNorth.show()
			wallWest.hide()
	#print("Wall visibility: %s/%s/%s/%s", wallSouth.vivible, wallEast.visible, wallNorth.visible, wallWest.visible)
