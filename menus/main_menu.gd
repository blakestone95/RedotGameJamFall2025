extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	pass # Replace with function body.
	get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_quit_pressed() -> void:
	pass # Replace with function body.
	get_tree().quit()

func _on_credits_pressed() -> void:
	pass # Replace with function body.
	#get_tree().change_scene_to_file("res://menus/credits.tscn")
	$Credits.show()
