extends CharacterBody2D


@onready var timer: Timer = $"../LightingTimer"
@onready var light: PointLight2D = $PointLight2D
@onready var health_bar: ProgressBar = $"../CanvasLayer/HealthBar"

@export var speed: int = 100
@export var REF_ARROW: PackedScene

var direction: Vector2 = Vector2.ZERO
var health: int = Globals.player_health
var enemy_in_range = false
var enemy_attack_cooldown = true
var shooting = false
var equipped = 1

var attack_ip = false
var current_dir = "none"


func _ready() -> void:
	timer.start()


func _process(delta: float) -> void:
	# Movement
	direction = Input.get_vector("left", "right", "up", "down")
	
	# Lighting
	var texture_scale = vision_time_left() / 15
	light.set_texture_scale(texture_scale)
	
	# Health
	health_bar.value = Globals.player_health


func _physics_process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()
	enemy_attack()
	attack()
	
	if Input.is_action_just_pressed("projectile_attack"):
		shoot_arrow()
	
	if Input.is_action_just_pressed("one"):
		if (equipped == 1):
			equipped = 0
			print(equipped)
			$"../CanvasLayer/MarginContainer/Slot".animation = "default"
			Globals.melee = false
			Globals.proj = false
		else:
			equipped = 1
			print(equipped)
			$"../CanvasLayer/MarginContainer/Slot".animation = "equipped"
			$"../CanvasLayer/MarginContainer/Slot2".animation = "default"
			$"../CanvasLayer/MarginContainer/Slot3".animation = "default"
			$"../CanvasLayer/MarginContainer/Slot4".animation = "default"
			$"../CanvasLayer/MarginContainer/Slot5".animation = "default"
			if Globals.sword:
				Globals.melee = true
				Globals.proj = false
	if Input.is_action_just_pressed("two"):
		if (equipped == 2):
			equipped = 0
			print(equipped)
			$"../CanvasLayer/MarginContainer/Slot2".animation = "default"
			Globals.melee = false
			Globals.proj = false
		else:
			equipped = 2
			print(equipped)
			$"../CanvasLayer/MarginContainer/Slot".animation = "default"
			$"../CanvasLayer/MarginContainer/Slot2".animation = "equipped"
			$"../CanvasLayer/MarginContainer/Slot3".animation = "default"
			$"../CanvasLayer/MarginContainer/Slot4".animation = "default"
			$"../CanvasLayer/MarginContainer/Slot5".animation = "default"
			if Globals.spear:
				Globals.melee = false
				Globals.proj = true
	if Input.is_action_just_pressed("three"):
		if (equipped == 3):
			equipped = 0
			print(equipped)
			$"../CanvasLayer/MarginContainer/Slot3".animation = "default"
			Globals.melee = false
			Globals.proj = false
		else:
			equipped = 3
			print(equipped)
			$"../CanvasLayer/MarginContainer/Slot".animation = "default"
			$"../CanvasLayer/MarginContainer/Slot2".animation = "default"
			$"../CanvasLayer/MarginContainer/Slot3".animation = "equipped"
			$"../CanvasLayer/MarginContainer/Slot4".animation = "default"
			$"../CanvasLayer/MarginContainer/Slot5".animation = "default"
			if Globals.bow:
				Globals.melee = false
				Globals.proj = true
	if Input.is_action_just_pressed("four"):
		if (equipped == 4):
			equipped = 0
			print(equipped)
			$"../CanvasLayer/MarginContainer/Slot4".animation = "default"
			Globals.melee = false
			Globals.proj = false
		else:
			equipped = 4
			print(equipped)
			$"../CanvasLayer/MarginContainer/Slot".animation = "default"
			$"../CanvasLayer/MarginContainer/Slot2".animation = "default"
			$"../CanvasLayer/MarginContainer/Slot3".animation = "default"
			$"../CanvasLayer/MarginContainer/Slot4".animation = "equipped"
			$"../CanvasLayer/MarginContainer/Slot5".animation = "default"
			if Globals.sword2:
				Globals.melee = true
				Globals.proj = false
	if Input.is_action_just_pressed("five"):
		if (equipped == 5):
			equipped = 0
			print(equipped)
			$"../CanvasLayer/MarginContainer/Slot5".animation = "default"
			Globals.melee = false
			Globals.proj = false
		else:
			equipped = 5
			print(equipped)
			$"../CanvasLayer/MarginContainer/Slot".animation = "default"
			$"../CanvasLayer/MarginContainer/Slot2".animation = "default"
			$"../CanvasLayer/MarginContainer/Slot3".animation = "default"
			$"../CanvasLayer/MarginContainer/Slot4".animation = "default"
			$"../CanvasLayer/MarginContainer/Slot5".animation = "equipped"
			if Globals.hammer:
				Globals.melee = true
				Globals.proj = false
	
	if (direction == Vector2.UP):
		$Sprite2D.animation = "N"
	else: if (direction == Vector2.RIGHT): 
		$Sprite2D.animation = "E"
	else: if (direction == Vector2.DOWN): 
		$Sprite2D.animation = "S"
	else: if (direction == Vector2.LEFT): 
		$Sprite2D.animation = "W"

func vision_time_left():
	var time_left = timer.time_left
	return time_left


func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_range = true


func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):	
		enemy_in_range = false


func enemy_attack():
	if enemy_in_range and enemy_attack_cooldown:
		Globals.player_health -= 15
		enemy_attack_cooldown = false
		$AttackTimer.start()
		if Globals.player_health <= 0:
			$"../CanvasLayer/Littletole".visible = true
			$"../CanvasLayer/Label".visible = true
			$"../CanvasModulate".visible = false
			queue_free()


func _on_attack_timer_timeout() -> void:
	enemy_attack_cooldown = true


func player():
	pass


func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("melee_attack"):
		Globals.player_current_attack = true
		attack_ip = true
		$DealDamageTimer.start()


func _on_deal_damage_timer_timeout() -> void:
	Globals.player_current_attack = false
	attack_ip = false
	$DealDamageTimer.stop()


func shoot_arrow():
	print("shoooot")
	
	if REF_ARROW and Globals.proj:
		var arrow = REF_ARROW.instantiate()
		get_tree().current_scene.add_child(arrow)
		arrow.global_position = self.global_position
		
		var arrow_rotation = self.global_position.direction_to(get_global_mouse_position()).angle()
		arrow.rotation = arrow_rotation


func _on_pickup_area_area_entered(area: Area2D) -> void:
	if area.name == "Spear":
		Globals.spear = true
		if $"../CanvasLayer/MarginContainer/Slot2".animation == "equipped":
			Globals.melee = false
			Globals.proj = true
	if area.name == "Sword2":
		Globals.sword2 = true
		if $"../CanvasLayer/MarginContainer/Slot4".animation == "equipped":
			Globals.melee = true
			Globals.proj = false
	if area.name == "Sword":
		Globals.sword = true
		if $"../CanvasLayer/MarginContainer/Slot".animation == "equipped":
			Globals.melee = true
			Globals.proj = false
	if area.name == "Hammer":
		Globals.hammer = true
		if $"../CanvasLayer/MarginContainer/Slot5".animation == "equipped":
			Globals.melee = true
			Globals.proj = false
	if area.name == "Bow":
		Globals.bow = true
		if $"../CanvasLayer/MarginContainer/Slot3".animation == "equipped":
			Globals.melee = false
			Globals.proj = true
	area.queue_free()
