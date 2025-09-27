extends CharacterBody2D

var speed = 75
@onready var player = $"../Player"
var motion = Vector2.ZERO


func _physics_process(delta: float) -> void:
	if player:
		var direction = position.direction_to(player.global_position).normalized()
		velocity = direction * speed
		move_and_slide()


func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body


func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
