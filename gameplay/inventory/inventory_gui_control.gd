class_name InventoryControl
extends Control

## Node containing an inventory. Optional, defaults to getting the colony invetory.
@export var inventory_source: Node
var inventory: Inventory

var slot_size = 64

func _ready() -> void:
	if inventory_source != null:
		if !inventory_source.is_node_ready(): await inventory_source.ready
		assert("inventory" in inventory_source, "Inventory Source MUST be a node with a property \"inventory\"")
		inventory = inventory_source.inventory
	else:
		var game = get_tree().get_nodes_in_group("game")[0] as Game;
		if !game.is_node_ready(): await game.ready
		inventory = game.colony_inventory
	
	assert(inventory != null, "Didn't find inventory in either Intentory source or \"Game\" node")
	
	for item in inventory.items.values():
		var slot = InventorySlot.new()
		slot.init(Vector2(slot_size, slot_size))
		$HBoxContainer.add_child(slot)
		var item_icon = InventoryItem.new()
		item_icon.init(item)
		slot.add_child(item_icon)
