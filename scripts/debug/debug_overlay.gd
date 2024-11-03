class_name DebugOverlay extends Control

@onready var mouse_position_label : Label = $MousePositionLabel
@onready var player_state_label: Label = $PlayerState
#@onready var label: Label = $VBoxContainer/Label

func update_debug_info(debug_info: String) -> void:
	player_state_label.text = debug_info

func _process(_delta: float) -> void:
	# Get the mouse position within the game viewport
	var mouse_position = get_viewport().get_mouse_position()
	
	# Global mouse pos
	# var mouse_position = DisplayServer.mouse_get_position()
	
	# Display the coordinates in the Label
	mouse_position_label.text = "Mouse Position: " + str(mouse_position)
