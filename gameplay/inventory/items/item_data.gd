class_name ItemData
extends Resource

enum Type {LEAF, STICK, PEBBLE, FOOD}
static var type_name_singular = {
	Type.LEAF: 'Leaf',
	Type.STICK: 'Stick',
	Type.PEBBLE: 'Pebble',
	Type.FOOD: 'Food',
}
static var type_name_plural = {
	Type.LEAF: 'Leaves',
	Type.STICK: 'Sticks',
	Type.PEBBLE: 'Pebbles',
	Type.FOOD: 'Food',
}

## Item type enum
@export var type: Type
## Item name
@export var name: String
## Item texture, currently 64x64 is our default size
@export var texture: Texture2D
## Current amount held
var count = 0
## Inventory cannot go over this amount. Attempting to increase by more than max
## will return the remainder after reaching max. A negative max will be treated
## as unlimited.
@export var max_amount: int

## Signal emitted if either increase or decrease are called, whether the count changes or not.
## Use this to know when the GUI needs to update.
signal updated

## Increase the item count by the passed amount.
## Returns the amount of items that couldn't fit.
func increase(amount: int) -> int:
	var sum: int = count + amount
	var remainder: int = 0
	if max_amount >= 0:
		if sum > max_amount:
			count = max_amount
			remainder = sum - max_amount
		else:
			count = sum
	updated.emit()
	return remainder

## Decrease the item count by the passed amount
## Returns the amount of items that couldn't be removed.
func decrease(amount: int) -> int:
	var sum: int = count - amount
	var remainder: int = 0
	if sum < 0:
		count = 0
		remainder = sum * -1
	else:
		count = sum
	updated.emit()
	return remainder
