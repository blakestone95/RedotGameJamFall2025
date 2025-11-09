extends Node2D

@export var speed = 200

func _process(delta: float) -> void:
	# Determine direction from inputs
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("character_right"):
		velocity.x += 1
	if Input.is_action_pressed("character_left"):
		velocity.x -= 1
	if Input.is_action_pressed("character_down"):
		velocity.y += 1
	if Input.is_action_pressed("character_up"):
		velocity.y -= 1

	# Get velocity and manage animation
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		# Rotate animation to angle of movement
		rotation = velocity.angle() + PI/2
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	
	
	# Move the character
	position += velocity * delta
