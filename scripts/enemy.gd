extends CharacterBody2D


@onready var player = $"../Player"

var speed = 75
var motion = Vector2.ZERO
var health = 100
var player_in_attack_zone = false
var can_take_damage = true


func _physics_process(delta: float) -> void:
	deal_with_damage()
	
	if player:
		var direction = position.direction_to(player.global_position).normalized()
		velocity = direction * speed
		move_and_slide()


func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body


func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null


func enemy():
	pass


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_zone = true


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_zone = false


func deal_with_damage():
	if player_in_attack_zone and Globals.player_current_attack == true:
		if can_take_damage:
			health -= 20
			$TakeDamageTimer.start()
			can_take_damage = false
			print(health)
			if health <= 0:
				self.queue_free()


func _on_take_damage_timer_timeout() -> void:
	can_take_damage = true
