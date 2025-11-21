extends Control

@onready var menu_select_sound: AudioStreamPlayer2D = $ButtonContainer/MenuSelectSound
@onready var menu_hover_sound: AudioStreamPlayer2D = $ButtonContainer/MenuHoverSound

func _on_start_pressed() -> void:
	menu_select_sound.play()
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_quit_pressed() -> void:
	menu_select_sound.play()
	get_tree().quit()

func _on_credits_pressed() -> void:
	menu_select_sound.play()
	$Credits.show()

func _on_options_pressed() -> void:
	menu_select_sound.play()
	$Tutorial.show()

func _on_start_mouse_entered() -> void:
	menu_hover_sound.play()
	pass

func _on_options_mouse_entered() -> void:
	menu_hover_sound.play()
	pass # Replace with function body.

func _on_credits_mouse_entered() -> void:
	menu_hover_sound.play()
	pass # Replace with function body.

func _on_quit_mouse_entered() -> void:
	menu_hover_sound.play()
	pass # Replace with function body.
