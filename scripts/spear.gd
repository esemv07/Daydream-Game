extends Area2D

@export var speed: int = 200

var direction: Vector2

func _physics_process(delta: float) -> void:
	direction = Vector2.RIGHT.rotated(rotation)
	global_position += direction * speed * delta * 2


func destroy():
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	destroy()


func _on_body_entered(body: Node2D) -> void:
	destroy()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	destroy()

func projectile():
	# PLACEHOLDER FOR DETECTION
	pass
