extends Label

## Message contents, put "%s" where you want the count to appear
@export var message: String = "The ants require %s food per day to survive!  More will be needed when the colony grows!"

var game

# Update the day counter every time this node enters the tree
func _enter_tree() -> void:
	if game == null: 
		game = get_tree().get_nodes_in_group("game")[0] as Game;
		if !game.is_node_ready(): await game.ready
	
	update_message()
	game.room_rebuilt.connect(update_message)

func update_message() -> void:
	text = message % str(game.get_req_food())
