class_name Inventory
extends Control

var slotSize = 64

var itemsLoad : Dictionary = {
	ItemData.Type.LEAF : "res://gameplay/inventory/items/Leaf.tres",
	ItemData.Type.STICK : "res://gameplay/inventory/items/Stick.tres",
	ItemData.Type.FOOD : "res://gameplay/inventory/items/Food.tres",
}

func _ready() -> void:
	for i in itemsLoad:
		var slot = InventorySlot.new()
		slot.init(Vector2(slotSize, slotSize))
		$HBoxContainer.add_child(slot)
		var item = InventoryItem.new()
		item.init(load(itemsLoad[i]))
		slot.add_child(item)
