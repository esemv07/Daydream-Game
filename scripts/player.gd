extends CharacterBody2D


@onready var animationplayer: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var timer: Timer = $"../LightingTimer"
@onready var light: PointLight2D = $PointLight2D
@onready var health_bar: ProgressBar = $"../CanvasLayer/HealthBar"

@export var speed: int = 100

var direction: Vector2 = Vector2.ZERO
var health: int = Globals.player_health
var enemy_in_range = false
var enemy_attack_cooldown = true

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
	
