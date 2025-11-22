extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"VBoxContainer/MASTER BAR".value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$"VBoxContainer/MUSIC BAR".value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$"VBoxContainer/SFX BAR".value = db_to_linear(AudioServer.get_bus_volume_db(2))

func _on_sf_xbar_mouse_exited() -> void:
	release_focus()


func _on_musicbar_mouse_exited() -> void:
	release_focus()


func _on_masterbar_mouse_exited() -> void:
	release_focus()
