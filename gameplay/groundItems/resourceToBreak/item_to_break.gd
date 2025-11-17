class_name ItemToBreak extends Area2D

@onready var foraging_progress: ProgressBar = $"../ForagingProgress"
@export var pickup_item : PackedScene
var id : int

func _ready() -> void:
	id = IdManager.get_id()

func _on_foraging_progress_progress_bar_completed() -> void:
	var number_items = randi_range(4,6)
	var angle = randf_range(0, 2*PI)
	var angle_increase = (2*PI)/number_items
	for i in range(number_items):
		var item = pickup_item.instantiate()
		var distance = randi_range(100, 200)
		item.position = Vector2.from_angle(angle + angle_increase * i) * distance
		item.global_position = to_global(item.position)
		get_parent().get_parent().add_child(item)
	get_parent().queue_free()

func breaking_progress(amount: float) -> void:
	foraging_progress.reduce_progress(amount)
