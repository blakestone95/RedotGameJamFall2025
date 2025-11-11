class_name InventoryControl
extends Control

## Node containing an inventory
@export var inventory_source: Node
var inventory: Inventory

var slot_size = 64

func _ready() -> void:
	await inventory_source.ready
	assert("inventory" in inventory_source, "Inventory Source MUST be a node with a property \"inventory\"")
	inventory = inventory_source.inventory
	for item in inventory.items.values():
		var slot = InventorySlot.new()
		slot.init(Vector2(slot_size, slot_size))
		$HBoxContainer.add_child(slot)
		var item_icon = InventoryItem.new()
		item_icon.init(item)
		slot.add_child(item_icon)
