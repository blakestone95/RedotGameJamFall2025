class_name InventoryItem
extends TextureRect

@export var item : ItemData
var counter = Label.new()


func init(d : ItemData) -> void:
	item = d

func _ready() -> void:
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture = item.texture
	counter.text = str(item.count)
	add_child(counter)
	
func decrease(amount: int):
	item.decrease(amount)
	counter.text = str(item.count)

func increase(amount: int):
	item.increase(amount)
	counter.text = str(item.count)
