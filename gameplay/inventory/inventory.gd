class_name Inventory
extends Control

var slotSize = 64

var itemsLoad = ["res://gameplay/inventory/items/Leaf.tres",
	"res://gameplay/inventory/items/Stick.tres",
	"res://gameplay/inventory/items/Food.tres",
	"res://gameplay/inventory/items/Pebble.tres"]

func _ready() -> void:
	for i in itemsLoad:
		var slot = InventorySlot.new()
		slot.init(Vector2(slotSize, slotSize))
		$HBoxContainer.add_child(slot)
		var item = InventoryItem.new()
		item.init(load(i))
		slot.add_child(item)
