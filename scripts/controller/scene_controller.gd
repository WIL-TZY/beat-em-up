class_name SceneController extends Node

@export_file (".tscn") var next_scene: String

@export var transition_type : ScreenTransition.TransitionType = Global.screen_transition.TransitionType.FADE
@export var emits_loaded_signal : bool = true

@onready var HUD: UI

var enemies := 0
var unlocked_at_area := 0.0
var last_area : bool = false

func _ready() -> void:
	Global.scene_controller = self
	HUD = Global.HUD

func activate() -> void:
	pass

func enemy_died() -> void:
	enemies -= 1
	
	if last_area: 
		# Ends the game if level is cleared
		HUD.__level_cleared()
		return
		
	if enemies <= 0:
		HUD.__show_go()
		_next_area(unlocked_at_area)

func _next_area(camera_limit: float) -> void:
	LevelController.camera.set_camera_limit(camera_limit)

func config_next_area(amount: int, unlocked: float) -> void:
	enemies = amount
	unlocked_at_area = unlocked
