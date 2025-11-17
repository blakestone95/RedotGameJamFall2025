extends Node

# For events you need to be able to call from anywhere

## Signal to be used when you need to update the game state in the game manager,
## such as when you start the exploration day with a button. Use the set_new_game_state
## utility method rather than manually emitting this signal.
signal update_game_state(new_state: Game.GameState)

func set_new_game_state(new_state: Game.GameState):
	update_game_state.emit(new_state)
