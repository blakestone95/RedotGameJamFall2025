extends Label

var game

# Update the day counter every time this node enters the tree
func _enter_tree() -> void:
	if game == null: game = get_tree().get_nodes_in_group("game")[0] as Game;
	text = "Day: " + str(game.day)
