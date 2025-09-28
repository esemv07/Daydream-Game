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
	health_bar.value = health


func _physics_process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()
	enemy_attack()
	attack()
	
	if Input.is_action_just_pressed("projectile_attack"):
		shoot_arrow()
	
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
		health -= 15
		enemy_attack_cooldown = false
		$AttackTimer.start()
		if health <= 0:
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
	
	if REF_ARROW:
		var arrow = REF_ARROW.instantiate()
		get_tree().current_scene.add_child(arrow)
		arrow.global_position = self.global_position
		
		var arrow_rotation = self.global_position.direction_to(get_global_mouse_position()).angle()
		arrow.rotation = arrow_rotation
