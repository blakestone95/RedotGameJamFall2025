extends Button

func _on_pressed() -> void:
	SignalManager.set_new_game_state(Game.GameState.EXPLORE)
