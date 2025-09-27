extends CharacterBody2D


@onready var animationplayer: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var timer: Timer = $"../Timer"
@onready var light: PointLight2D = $PointLight2D

@export var speed: int = 96

var direction: Vector2 = Vector2.ZERO


func _ready() -> void:
	timer.start()


func _process(delta: float) -> void:
	# Movement
	direction = Input.get_vector("left", "right", "up", "down")
	
	# Lighting
	var texture_scale = vision_time_left() / 15
	light.set_texture_scale(texture_scale)


func _physics_process(delta: float) -> void:
	velocity = direction * speed * 2
	move_and_slide()
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
	
