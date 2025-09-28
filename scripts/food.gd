extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		if Globals.player_health <= 90:
			Globals.player_health += 10
		else:
			Globals.player_health = 100
		queue_free()
