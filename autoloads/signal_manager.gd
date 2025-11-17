extends Node

# For events you need to be able to call from anywhere

## Signal to be used when you need to update the game state in the game manager,
## such as when you start the exploration day with a button
signal update_game_state
