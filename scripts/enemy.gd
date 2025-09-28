extends CharacterBody2D


@onready var player = $"../Player"

var speed = 50
var motion = Vector2.ZERO
var health = 100
var player_in_attack_zone = false
var can_take_damage = true
var proj_in_hitbox = false
var weapon_name = ""
var weapon_path = ""
var weapon_drop

var weapons = {
	"sword": preload("res://scenes/Sword.tscn"),
	"spear": preload("res://scenes/Spear_Collect.tscn"),
	"bow": preload("res://scenes/Bow.tscn"),
	"sword2": preload("res://scenes/Sword2.tscn"),
	"hammer": preload("res://scenes/Hammer.tscn"),
}

func _ready() -> void:
	pass


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



func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_zone = false




func deal_with_damage():
	if player_in_attack_zone and Globals.player_current_attack and Globals.melee:
		if can_take_damage:
			health -= 20
			$TakeDamageTimer.start()
			can_take_damage = false
			if health <= 0:
				var size = weapons.size()
				var random = weapons.keys()[randi() % size]
				weapon_path = weapons[random].instantiate()
				weapon_path.position = position
				print("dropped")
				self.queue_free()
	elif proj_in_hitbox:
		print("detected")
		if can_take_damage:
			health -= 20
			$TakeDamageTimer.start()
			can_take_damage = false
			proj_in_hitbox = false
			if health <= 0:
				var size = weapons.size()
				var random = weapons.keys()[randi() % size]
				weapon_path = weapons[random].instantiate()
				weapon_path.position = position
				print("dropped")
				self.queue_free()


func _on_take_damage_timer_timeout() -> void:
	can_take_damage = true


func _on_enemy_hitbox_area_entered(area: Area2D) -> void:
	if area.has_method("projectile"):
		proj_in_hitbox = true


func _on_enemy_hitbox_area_exited(area: Area2D) -> void:
	if area.has_method("projectile"):
		proj_in_hitbox = false
