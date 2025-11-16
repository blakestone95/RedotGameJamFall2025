"""
	This is the main rubble pile making them all collapse at the same time
	By : Stingray
"""

extends Node2D
@onready var rubblepile: Node2D = $"."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("test_rubble"):
		var child_of_rubble := get_children()
		for child in child_of_rubble:
			child.rubble_fall()
