extends Resource
class_name MaskComboData

@export var mask_type: String
@export var eye_color: String
@export_multiline var clues: Array[String]

func matches(npc_mask_type: String, npc_eye_color: String) -> bool:
	return mask_type == npc_mask_type and eye_color == npc_eye_color
