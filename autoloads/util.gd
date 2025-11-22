extends Node

# Project utility functions that should be accessible anywhere

static func roll_with_chance(chance: float) -> bool:
	assert(chance < 1.0, "Chance should be a float between 0 and 1.0")
	var roll: float = randf()
	return roll < chance
