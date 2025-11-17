extends Camera2D

@export var speed: int = 800
@export var bounding_box: Sprite2D

var dragging: bool = false

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
		var new_position = position + velocity.normalized() * speed * delta
		update_position(new_position)

# Handle mouse movement (dragging)
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		dragging = event.pressed
	if dragging and event is InputEventMouseMotion:
		update_position(position - event.relative)
		

func update_position(new_position: Vector2) -> void:
	var view_rect = get_viewport_rect()
	var bounding_rect = bounding_box.get_rect()
	bounding_rect.position = bounding_rect.position + (view_rect.size / 2)
	bounding_rect.size = (bounding_rect.size - view_rect.size).max(Vector2.ZERO)
	position = new_position.clamp(bounding_rect.position, bounding_rect.end)
