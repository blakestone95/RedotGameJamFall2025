class_name Inventory

var slotSize = 64

## Indexed with ItemData.Type and contains ItemData
var items: Dictionary = {}

## Signal emitted if either increase or decrease are called, whether the count changes or not.
## Use this to know when the GUI needs to update.
signal updated(type: ItemData.Type)

func _init(item_data: Dictionary):
	# Validate data
	for item in item_data.values():
		assert(item is ItemData, "All values of item_data passed to Inventory must be ItemData")
	items = item_data

func increase_item(type: ItemData.Type, amount: int) -> int:
	# Could add the item, but since the items are ItemData types, there's info you'd be missing. So let's just error here.
	assert(items.has(type), "Attempted to increase item not in this inventory")
	var remainder = items[type].increase(amount)
	updated.emit(type)
	return remainder

func decrease_item(type: ItemData.Type, amount: int) -> int:
	assert(items.has(type), "Attempted to decrease item not in this inventory")
	var remainder = items[type].decrease(amount)
	updated.emit(type)
	return remainder
