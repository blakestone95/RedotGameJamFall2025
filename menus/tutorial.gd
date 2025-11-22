extends Control

@onready var buttonhover: AudioStreamPlayer2D = $BackButton/Buttonhover
@onready var buttonselect: AudioStreamPlayer2D = $BackButton/Buttonselect

func _on_back_button_pressed() -> void:
	buttonselect.play()
	self.hide()

func _on_back_button_mouse_entered() -> void:
	buttonhover.play()
	pass # Replace with function body.
