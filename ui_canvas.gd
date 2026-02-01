extends CanvasLayer
class_name UICanvas

@onready var bottomTextBoxControl: Control = $BottomTextBox
@onready var bottomTextBoxLabel: Label = $BottomTextBox/MarginContainer/FlowContainer/Label
@onready var bottomTextBoxTextureRect: TextureRect = $BottomTextBox/MarginContainer/FlowContainer/TextureRect

func show_bottom_text_box(text: String, mask: Texture2D) -> void:
	bottomTextBoxLabel.text = text
	bottomTextBoxTextureRect.texture = mask
	bottomTextBoxControl.show()

func hide_bottom_text_box() -> void:
	bottomTextBoxControl.hide()
