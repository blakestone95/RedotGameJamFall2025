"""
	This is the main rubble pile making them all collapse at the same time
	By : Stingray
"""

class_name RubblePile extends Node2D

func rubble_fall() -> void:
	var child_of_rubble := get_children()
	for child in child_of_rubble:
		child.rubble_fall()
