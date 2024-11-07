class_name TitleScreen extends BaseScene

enum MenuState { MENU, INTRO, SELECT }

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var menu_state = MenuState.MENU

func _ready() -> void:
	super()

func _process(_delta: float) -> void:
	super(_delta)
	
	if Input.is_action_just_pressed("ui_accept"):
		match menu_state:
			MenuState.MENU:
				__play_intro()
			MenuState.INTRO:
				__open_character_selector()

func __play_intro() -> void:
	menu_state = MenuState.INTRO
	get_node("Title").hide()
	get_node("Intro").show()
	animation_player.play("intro")

func __open_character_selector() -> void:
	menu_state = MenuState.SELECT
	
	# Screen transition
	SceneManager.transition(next_scene, transition_type)
