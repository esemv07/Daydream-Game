extends ProgressBar

@onready var timer: Timer = $"../../LightingTimer"


func _ready() -> void:
	max_value = timer.wait_time

func _process(delta: float) -> void:
	if (value >= 12):
		value = max_value - timer.time_left
	else: if (max_value - timer.time_left > 0):
		value = 12
	else:
		value = 0
