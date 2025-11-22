extends Button

@onready var button_select: AudioStreamPlayer2D = $"../../../../ButtonSelect"
@onready var button_hover: AudioStreamPlayer2D = $"../../../../ButtonHover"

func _on_pressed() -> void:
	button_select.play()
	SignalManager.set_new_game_state(Game.GameState.EXPLORE)

func _on_button_hover() -> void:
	button_hover.play()
