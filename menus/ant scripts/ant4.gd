extends PathFollow2D

var speed = 0.01

func  _process(delta):
	loop_movement(delta)

func loop_movement(delta):
	progress_ratio += delta * speed
