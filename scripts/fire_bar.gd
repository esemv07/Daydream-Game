extends ProgressBar

@onready var timer: Timer = $"../../LightingTimer"


func _ready() -> void:
	$"../MarginContainer/AnimatedSprite2D".play("default")
	max_value = timer.wait_time

func _process(delta: float) -> void:
	value = timer.time_left
	$"../MarginContainer/AnimatedSprite2D".scale = Vector2(8,8) * (timer.time_left/45)
