extends PathFollow2D

var speed = 0.009

func  _process(delta):
	loop_movement(delta)

func loop_movement(delta):
	progress_ratio += delta * speed
