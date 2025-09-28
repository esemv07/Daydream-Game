extends Area2D

@export var speed: int = 200

var direction: Vector2

func _physics_process(delta: float) -> void:
	direction = Vector2.RIGHT.rotated(rotation)
	global_position += direction * speed * delta


func destroy():
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	print(area)
	destroy()


func _on_body_entered(body: Node2D) -> void:
	print(body)
	destroy()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("bye bye")
	destroy()
