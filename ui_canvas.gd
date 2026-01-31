extends CanvasLayer
class_name UICanvas

@onready var bottomTextBoxControl: Control = $BottomTextBox
@onready var bottomTextBoxLabel: Label = $BottomTextBox/MarginContainer/Label

func show_bottom_text_box(text: String) -> void:
	bottomTextBoxLabel.text = text
	bottomTextBoxControl.show()

func hide_bottom_text_box() -> void:
	bottomTextBoxControl.hide()
