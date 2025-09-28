extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.sword:
		%SwordSlot.visible = true
	else:
		%SwordSlot.visible = false
	if Globals.spear:
		%Spear.visible = true
	else:
		%Spear.visible = false
	if Globals.bow:
		%Bow.visible = true
	else:
		%Bow.visible = false
	if Globals.sword2:
		%Sword2.visible = true
	else:
		%Sword2.visible = false
	if Globals.hammer:
		%Hammer.visible = true
	else:
		%Hammer.visible = false
