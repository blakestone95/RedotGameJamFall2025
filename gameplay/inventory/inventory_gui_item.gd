class_name InventoryItem
extends TextureRect

# Set from InventoryControl
var item: ItemData
var counter = Label.new()

func init(d: ItemData) -> void:
	item = d
	item.connect("updated", _on_inventory_update)

func _ready() -> void:
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture = item.texture
	update_counter()
	add_child(counter)

func _on_inventory_update():
	update_counter()

func update_counter():
	if item.max_amount >= 0:
		counter.text = str(item.count) + "/" + str(item.max_amount)
	else:
		counter.text = str(item.count)
