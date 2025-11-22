extends Control
@onready var option_menu: Control = $"."
@onready var hotkey: Control = $TabContainer/controls/InputSetting


func _on_apply_pressed() -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db($"TabContainer/audio/audio options/VBoxContainer/MASTER BAR".value))
	AudioServer.set_bus_volume_db(1, linear_to_db($"TabContainer/audio/audio options/VBoxContainer/MUSIC BAR".value))
	AudioServer.set_bus_volume_db(2, linear_to_db($"TabContainer/audio/audio options/VBoxContainer/SFX BAR".value))


func _on_back_pressed() -> void:
	option_menu.hide()
