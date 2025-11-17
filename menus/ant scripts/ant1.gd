extends PathFollow2D

var speed = 0.02

func  _process(delta):
	loop_movement(delta)

func loop_movement(delta):
	progress_ratio += delta * speed

func _ready() -> void:
	get_node("AnimatedSprite2D").play()
