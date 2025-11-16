class_name OverworldColony extends Area2D

@export var colony: Node
# Store a reference to the global inventory for ease of use
var inventory: Inventory

func _ready() -> void:
	var game_node = find_parent("Game");
	await game_node.ready
	assert("colony_inventory" in game_node, "OverworldColony must be the descendant of a Game node with the colony_inventory property set")
	inventory = game_node.colony_inventory
