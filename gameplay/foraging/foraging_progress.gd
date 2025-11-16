extends ProgressBar


signal progress_bar_completed

func reduce_progress(amount: float):
	visible = true
	value = max(0, value - amount)
	if value == 0:
		progress_bar_completed.emit()
