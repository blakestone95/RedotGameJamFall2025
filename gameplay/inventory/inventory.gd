class_name Inventory

var slotSize = 64

## Indexed with ItemData.Type and contains ItemData
var items: Dictionary = {}

func _init(item_data: Dictionary):
	# Validate data
	for item in item_data.values():
		assert(item is ItemData, "All values of item_data passed to Inventory must be ItemData")
	items = item_data

func increase_item(type: ItemData.Type, amount: int):
	items[type].increase(amount)

func decrease_item(type: ItemData.Type, amount: int):
	items[type].decrease(amount)
