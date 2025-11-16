class_name Pickup extends Area2D

@export var pickup_type: ItemData.Type
@export var root: Node
var id: int

func _ready() -> void:
	id = IdManager.get_id()

func pickup() -> void:
	root.queue_free()
