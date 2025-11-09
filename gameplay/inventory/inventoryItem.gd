class_name InventoryItem
extends TextureRect

@export var item : ItemData

func init(d : ItemData) -> void:
	item = d

func _ready() -> void:
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture = item.texture
