extends CharacterBody2D


@onready var animationplayer: AnimationPlayer = $Sprite2D/AnimationPlayer

@export var speed: int = 50

var direction: Vector2 = Vector2.ZERO



func _process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")


func _physics_process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()
