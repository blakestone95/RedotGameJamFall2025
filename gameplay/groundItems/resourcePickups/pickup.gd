class_name Pickup extends Area2D

@export var pickup_type: ItemData.Type
@export var root: Node
var id: int

@onready var prompt = $"../PickupPrompt"

func _ready() -> void:
	id = IdManager.get_id()
	area_entered.connect(show_interaction_prompt)
	area_exited.connect(hide_interaction_prompt)

func pickup() -> void:
	root.queue_free()

func show_interaction_prompt(_area: Area2D) -> void:
	prompt.show()

func hide_interaction_prompt(_area: Area2D) -> void:
	prompt.hide()
