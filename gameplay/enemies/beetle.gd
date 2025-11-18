extends Node2D


func _on_detection_zone_body_entered(body: Node2D) -> void:
	if body is Antonia:
		print("Antonia entered!")
