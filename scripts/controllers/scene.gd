class_name Scene extends Node

@export_file (".tscn") var next_scene: String

@export var transition_type : ScreenTransition.TransitionType = Global.screen_transition.TransitionType.FADE
@export var emits_loaded_signal : bool = true

# Idk what to do with this yet
func activate() -> void:
	pass
