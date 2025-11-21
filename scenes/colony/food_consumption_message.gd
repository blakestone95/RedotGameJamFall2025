extends Label

## Message contents, put "%s" where you want the count to appear
@export var message: String = "The ants require %s food per day to survive! Each room rebuilt will need %s extra food each day."

var game: Game

# Update the day counter every time this node enters the tree
func _enter_tree() -> void:
	if game == null: 
		game = get_tree().get_nodes_in_group("game")[0] as Game;
		if !game.is_node_ready(): await game.ready
	
	update_message()
	game.room_rebuilt.connect(update_message)

func update_message() -> void:
	text = message % [str(game.get_req_food()), str(game.food_increase_per_room)]
