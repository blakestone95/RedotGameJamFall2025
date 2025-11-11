class_name Game extends Node2D

var colony_inventory: Inventory
## Provide the ItemData resources in the order you want them to appear
@export var inventory_items: Array[ItemData]

func _ready() -> void:
	# Set up inventory
	var intentory_data: Dictionary = {}
	for item in inventory_items:
		intentory_data[item.type] = item.duplicate()
	colony_inventory = Inventory.new(intentory_data)
