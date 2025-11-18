extends Node2D


var start_position: Vector2

func _ready() -> void:
	start_position = global_position

func _on_detection_zone_body_entered(body: Node2D) -> void:
	if body is Antonia:
		print("Antonia entered!")
