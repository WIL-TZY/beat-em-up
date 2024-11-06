class_name BaseScene extends Node

signal loaded()

@export_file (".tscn") var next_scene: String

@export var transition_type: SceneManager.TransitionType = SceneManager.TransitionType.FADE
@export var emits_loaded_signal : bool = true

func _ready() -> void:
	# Hides the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	# DEBUG current scene
	# OBS: 
	print(SceneManager.current_scene)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().quit()  # Exit the game

func _process(_delta: float) -> void:
	# DEBUG
	if Input.is_action_just_pressed("switch_scene"):
		SceneManager.transition_to(next_scene)

func activate() -> void:
	pass

func load_scene() -> void:
	if SceneManager.transition_type == SceneManager.TransitionType.FADE:
		await get_tree().create_timer(1.0).timeout
	else:
		await get_tree().create_timer(0.1).timeout
	loaded.emit()
