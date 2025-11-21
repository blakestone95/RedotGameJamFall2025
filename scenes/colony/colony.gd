class_name Colony extends Node2D

enum Rooms {RANCH, FARM, GUARD, HOUSES, ROYAL_CHAMBERS, SCOUT, STORAGE}

# Room state is managed by the RebuildButtons
@onready var button_hover: AudioStreamPlayer2D = $ButtonHover


func _on_aphid_ranch_rebuild_button_mouse_entered() -> void:
	button_hover.play()
	pass # Replace with function body.

func _on_fungus_farm_rebuild_button_mouse_entered() -> void:
	button_hover.play()
	pass # Replace with function body.

func _on_guard_rebuild_button_mouse_entered() -> void:
	button_hover.play()
	pass # Replace with function body.

func _on_houses_rebuild_button_mouse_entered() -> void:
	button_hover.play()
	pass # Replace with function body.

func _on_royal_chamber_rebuild_button_mouse_entered() -> void:
	button_hover.play()
	pass # Replace with function body.

func _on_scout_rebuild_button_mouse_entered() -> void:
	button_hover.play()
	pass # Replace with function body.

func _on_storage_rebuild_button_mouse_entered() -> void:
	button_hover.play()
	pass # Replace with function body.


func _on_start_button_mouse_entered() -> void:
	button_hover.play()
	pass # Replace with function body.
