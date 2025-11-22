class_name AntoniaHealthBar extends ProgressBar

signal lost_all_hp

func _ready() -> void:
	value = max_value

func take_damage(amount: int):
	value -= amount
	if value <= 0:
		lost_all_hp.emit()

func _on_value_changed(value: float) -> void:
	$Label.text = str(value) + "hp"
