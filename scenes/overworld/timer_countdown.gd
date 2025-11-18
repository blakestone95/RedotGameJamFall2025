extends Label

@export var expiration_warning: int = 15
var game: Game

func _enter_tree() -> void:
	# Get the game node so we can access the inventory
	if game == null: 
		game = get_tree().get_nodes_in_group("game")[0] as Game;
		if !game.is_node_ready(): await game.ready
		
func _process(_delta: float) -> void:
	var time_left: int = ceili(game.exploration_timer.time_left)
	var min_left = time_left / 60
	var sec_left = time_left % 60
	
	# Add the preceding 0 to seconds if necessary
	var sec_str = str(sec_left)
	if sec_left < 10: sec_str = "0" + sec_str
	
	# Set the timer's text
	text = str(min_left) + ":" + sec_str
	
	# Change the timer's color to red if below warning threshold
	if time_left <= expiration_warning:
		add_theme_color_override("font_color", Color(0.9, 0, 0))
	else:
		remove_theme_color_override("font_color")
