extends PanelContainer

@export var item: ItemData

@onready var label = $MarginContainer/HBoxContainer/Label
@onready var texture_rect = $MarginContainer/HBoxContainer/TextureRect

var game: Game

func _ready() -> void:
	game = get_tree().get_nodes_in_group("game")[0] as Game;
	if !game.is_node_ready(): await game.ready
	assert("colony_inventory" in game, "Colonyinventory requires the Game node to be in the tree with the colony_inventory property set")
	texture_rect.texture = item.texture
	update_label()
	game.colony_inventory.items[item.type].updated.connect(update_label)

func update_label() -> void:
	var count = game.colony_inventory.items[item.type].count
	label.text = str(count)
