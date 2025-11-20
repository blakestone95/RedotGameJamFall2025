extends Node2D


enum State {
	IDLE,
	TARGETING,
	ATTACKING,
	RETREATING
}

var current_state : State = State.IDLE

var start_position: Vector2
var rotation_speed = 0.01
var speed : int = 200
var target: Antonia
var target_position : Vector2
var arrival_position: Vector2

func _ready() -> void:
	start_position = global_position

func _on_detection_zone_body_entered(body: Node2D) -> void:
	if body is Antonia and current_state == State.IDLE:
		target = body
		current_state = State.TARGETING
	
func _process(delta: float) -> void:
	if current_state == State.TARGETING and $Timer.is_stopped():
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.speed_scale = 1
		var angle_to_antonia = get_angle_to(target.global_position)
		if abs(angle_to_antonia) < rotation_speed:
			$Timer.start()
			target_position = target.global_position
			# Goes a bit further than where is the player
			arrival_position = global_position + (1.5 * (target_position - global_position))
			$AnimatedSprite2D.speed_scale = 2
		else:
			if angle_to_antonia > 0:
				rotate(rotation_speed)
			else:
				rotate(-1 * rotation_speed)
				
	if current_state == State.ATTACKING:
		global_position += global_position.direction_to(arrival_position) * speed * 2 * delta
		if (arrival_position - global_position).length() < speed * 2 * delta:
			if (global_position - start_position).length() > $DetectionZone/CollisionShape2D.shape.radius * 2:
				rotation = rotation + get_angle_to(start_position)
				current_state = State.RETREATING
			else:
				current_state = State.TARGETING

				
	if current_state == State.RETREATING:
		$AnimatedSprite2D.speed_scale = 1
		global_position += global_position.direction_to(start_position) * speed * delta
		if (start_position - global_position).length() < speed * delta:
			rotation = -PI/2
			current_state = State.IDLE
			$AnimatedSprite2D.frame = 0
			$AnimatedSprite2D.pause()

		
		 
func _on_timer_timeout() -> void:
	current_state = State.ATTACKING
	$AnimatedSprite2D.speed_scale = 3

	
	
	
	
