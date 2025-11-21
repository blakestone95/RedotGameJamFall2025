extends ProgressBar

@onready var chomping_sound: AudioStreamPlayer2D = $ChompingSound

signal progress_bar_completed

func reduce_progress(amount: float):
	if not chomping_sound.playing:
		chomping_sound.play()
	visible = true
	value = max(0, value - amount)
	if value == 0:
		chomping_sound.stop()
		progress_bar_completed.emit()
