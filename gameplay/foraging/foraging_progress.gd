extends ProgressBar


func _ready() -> void:
	$Timer.wait_time = max_value

func start_timer() -> void:
	if $Timer.is_stopped():
		$Timer.start()
		
