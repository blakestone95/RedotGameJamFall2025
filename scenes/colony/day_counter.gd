extends Label

func _ready() -> void:
	var game = get_tree().get_nodes_in_group("game")[0] as Game
	await game.ready
	text = "Day: " + str(game.day)
