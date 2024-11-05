class_name BaseScene extends Node

func _ready() -> void:
	# Hides the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().quit() # Exit the game

# (TO-DO) Add more functions for handling audio, managing global game states, etc
