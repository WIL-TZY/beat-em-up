extends CanvasLayer

enum MenuState { NULL, MENU, INTRO, SELECT }

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var menu_state = MenuState.MENU

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		match menu_state:
			MenuState.MENU:
				__play_intro()
			MenuState.INTRO:
				__open_character_selector()

func __play_intro() -> void:
	menu_state = MenuState.INTRO
	get_node("Menu").hide()
	get_node("Intro").show()
	animation_player.play("intro")

func __open_character_selector() -> void:
	menu_state = MenuState.SELECT
	get_tree().change_scene_to_file("res://scenes/ui/ui_player_selector.tscn")
