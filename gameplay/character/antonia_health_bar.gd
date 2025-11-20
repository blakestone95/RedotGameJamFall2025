class_name AntoniaHealthBar extends ProgressBar


func _ready() -> void:
	value = max_value

func take_damage(amount: int):
	value -= amount

func _on_value_changed(value: float) -> void:
	$Label.text = str(value) + "hp"
