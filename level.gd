extends Node3D
class_name Level

@export var combo_database: Array[MaskComboData]

@onready var guests: Node3D = $Guests

func _ready() -> void:
	for child in guests.get_children():
		child.add_to_group("npcs")
		var npc = child as Npc
		var mask = npc.get_mask_details()
		npc.add_to_group(mask.type + "__" + mask.material)

func get_clue(selected: Array[Npc]) -> Dictionary[String, String]:
	var mask_type: String
	var eye_color: String
	
	if selected.size() == 1:
		return {"result": "single", "text": "You start looking for clues.\nThis person looks interesting..."}
	
	for npc in selected:
		var mask = npc.get_mask_details()
		if mask_type.length() == 0 and eye_color.length() == 0:
			mask_type = mask.type
			eye_color = mask.material
		
		if mask_type != mask.type or eye_color != mask.material:
			return {"result": "mismatch", "text": "You feel a disturbance in the force, those masks don't match."}
	
	for data in combo_database:
		if data.matches(mask_type, eye_color):
			if (selected.size() - 1) > data.clues.size():
				return {"result": "exhausted", "text": "This clue seems to be exhausted. Time to move to the next one."}
			var result = "clue"
			if (selected.size() - 1) == data.clues.size():
				result = "last_clue"
			return {"result": result, "text": data.clues[selected.size() - 2]}
	
	return {"result": "nothing", "text": "You sense a weird echo but gain no clues."}
	
