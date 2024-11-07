class_name MainScene extends Node

signal loaded()

@onready var screen_transition: ScreenTransition = $Transitions/ScreenTransition
@onready var main_control: CanvasLayer = $MainControl
@onready var main3D : Node3D = $Main3D
var scene_instance : Node = null

func _ready() -> void:
	# Hides the mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	Global.main_scene = self
	
	# Load first scene
	load_scene("res://scenes/screens/title_screen.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().quit()  # Exit the game

func _process(_delta: float) -> void:
	# DEBUG
	#if Input.is_action_just_pressed("switch_scene"):
		#screen_transition.transition(next_scene, transition_type)
		pass

func load_scene(screen_name: String) -> void:
	unload_scene()

	var scene_resource := load(screen_name)
	if scene_resource:
		scene_instance = scene_resource.instantiate()
		if scene_instance.is_class("Control"):
			if not scene_instance.is_inside_tree(): main_control.add_child(scene_instance)
		elif scene_instance.is_class("Node3D"):
			if not scene_instance.is_inside_tree(): main3D.add_child(scene_instance)
	
	# Simulate wait time
	if screen_transition.transition_type == screen_transition.TransitionType.FADE:
		await get_tree().create_timer(1.0).timeout
	else:
		await get_tree().create_timer(0.1).timeout
	
	loaded.emit()

func unload_scene() -> void:
	if is_instance_valid(scene_instance):
		scene_instance.queue_free()
	scene_instance = null
