extends Node3D

@onready var wallEast : MeshInstance3D = $Wall00
@onready var wallNorth : MeshInstance3D = $Wall01
@onready var wallWest : MeshInstance3D = $Wall02
@onready var wallSouth : MeshInstance3D = $Wall03

func SetWallVisibility(direction):
	match direction:
		"southeast":
			wallSouth.visible = false
			wallEast.visible = false
			wallNorth.visible = true
			wallWest.visible = true
		"northeast":
			wallSouth.visible = true
			wallEast.visible = false
			wallNorth.visible = false
			wallWest.visible = true
		"northwest":
			wallSouth.visible = true
			wallEast.visible = true
			wallNorth.visible = false
			wallWest.visible = false
		"southwest":
			wallSouth.visible = false
			wallEast.visible = true
			wallNorth.visible = false
			wallWest.visible = true
