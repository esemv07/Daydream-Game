extends CharacterBody2D


@onready var player = $"../Player"

var speed = 50
var motion = Vector2.ZERO
var health = 100
var player_in_attack_zone = false
var can_take_damage = true
var proj_in_hitbox = false


func _physics_process(delta: float) -> void:
	$HealthBar.value = health
	
	deal_with_damage()
	
	if player:
		var direction = position.direction_to(player.global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		
		
		if position > player.global_position:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false


func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body


func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null


func enemy():
	pass


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_zone = true
	if body.has_method("projectile"):
		proj_in_hitbox = true


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_zone = false
	if body.has_method("projectile"):
		proj_in_hitbox = false


func deal_with_damage():
	if player_in_attack_zone and Globals.player_current_attack == true:
		if can_take_damage:
			health -= 20
			$TakeDamageTimer.start()
			can_take_damage = false
			if health <= 0:
				self.queue_free()
	elif proj_in_hitbox:
		if can_take_damage:
			health -= 20
			$TakeDamageTimer.start()
			can_take_damage = false
			proj_in_hitbox = false
			if health <= 0:
				self.queue_free()


func _on_take_damage_timer_timeout() -> void:
	can_take_damage = true
