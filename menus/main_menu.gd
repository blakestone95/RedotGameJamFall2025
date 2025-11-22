extends Control

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Game.tscn")
	
func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_credits_pressed() -> void:
	$Credits.show()

func _on_options_pressed() -> void:
	$"option menu".show()
func _on_how_to_play_pressed() -> void:
	$Tutorial.show()
