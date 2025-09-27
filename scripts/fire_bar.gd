extends ProgressBar

@onready var timer: Timer = $"../../LightingTimer"


func _ready() -> void:
	max_value = timer.wait_time

func _process(delta: float) -> void:
	value = max_value - timer.time_left
