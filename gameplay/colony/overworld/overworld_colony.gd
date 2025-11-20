class_name OverworldColony extends Area2D

@export var colony: Node
# Store a reference to the global inventory for ease of use
var inventory: Inventory

@onready var prompt = $"../DepositPrompt"

func _ready() -> void:
	var game = get_tree().get_nodes_in_group("game")[0] as Game;
	if !game.is_node_ready(): await game.ready
	assert("colony_inventory" in game, "Colonyinventory requires the Game node to be in the tree with the colony_inventory property set")
	inventory = game.colony_inventory
	area_entered.connect(show_interaction_prompt)
	area_exited.connect(hide_interaction_prompt)

func show_interaction_prompt(_area: Area2D) -> void:
	prompt.show()

func hide_interaction_prompt(_area: Area2D) -> void:
	prompt.hide()
