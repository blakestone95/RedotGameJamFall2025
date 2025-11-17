class_name OverworldColony extends Area2D

@export var colony: Node
# Store a reference to the global inventory for ease of use
var inventory: Inventory

func _ready() -> void:
	var game = get_tree().get_nodes_in_group("game")[0] as Game;
	if !game.is_node_ready(): await game.ready
	assert("colony_inventory" in game, "OverworldColony must be the descendant of a Game node with the colony_inventory property set")
	inventory = game.colony_inventory
