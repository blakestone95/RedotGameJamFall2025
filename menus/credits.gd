extends Control

@onready var button_hover: AudioStreamPlayer2D = $ButtonHover
@onready var button_select: AudioStreamPlayer2D = $ButtonSelect

func _on_back_button_pressed() -> void:
	button_select.play()
	self.hide()

func _on_back_button_mouse_entered() -> void:
	button_hover.play()
	pass # Replace with function body.
