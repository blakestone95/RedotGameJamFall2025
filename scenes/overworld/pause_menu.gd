extends Control
@onready var option_menu: Control = $"option menu"

func _open() -> void:
	get_tree().paused = true
	show()
	
func _close() -> void:
	get_tree().paused = false
	hide()

func _end_day() -> void:
	_close()
	SignalManager.set_new_game_state(Game.GameState.REBUILD)


func _on_option_button_pressed() -> void:
	$"option menu".show()
