extends Node2D


enum State {
	IDLE,
	ATTACKING,
	RETREATING
}

var speed : int = 200
var rotation_speed = 0.1

@onready var start_position = global_position
var target: Antonia
var current_state : State = State.IDLE
var idle_position : Vector2
var nb_idle_positions = 8
var idle_positions : Array[Vector2] = []

func _ready() -> void:
	# Set up o
	for i in range(nb_idle_positions):
		var x = cos(2*i*PI/nb_idle_positions)
		var y = sin(2*i*PI/nb_idle_positions)
		idle_positions.append(global_position + Vector2(x*150, y*150))

func _on_detection_zone_body_entered(body: Node2D) -> void:
	if body is Antonia:
		target = body
		current_state = State.ATTACKING
		$AnimatedSprite2D.speed_scale = 2
		$Timer.stop()

func _on_detection_zone_body_exited(body: Node2D) -> void:
	if body is Antonia:
		target = null
		current_state = State.RETREATING
		$AnimatedSprite2D.speed_scale = 1
		rotation += get_angle_to(start_position)
		
func _process(delta: float) -> void:
	if current_state == State.ATTACKING:
		rotation += get_angle_to(target.global_position)
		global_position += global_position.direction_to(target.global_position) * speed * delta
		
	if current_state == State.RETREATING:
		global_position += global_position.direction_to(start_position) * speed * delta
		if (global_position - start_position).length() < speed * delta:
			current_state = State.IDLE
			$Timer.start()
	
	if current_state == State.IDLE:
		rotation += get_angle_to(idle_position)
		if (global_position - idle_position).length() > speed * delta:
			global_position += global_position.direction_to(idle_position) * speed * delta
			
func _on_timer_timeout() -> void:
	var idle_position_index = randi_range(0, idle_positions.size()-1)
	idle_position = idle_positions[idle_position_index]
	$Timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Antonia:
		target = null
		current_state = State.RETREATING
		$AnimatedSprite2D.speed_scale = 1
		rotation += get_angle_to(start_position)
