class_name PlayerSelector extends Scene

@onready var animated_brawler_girl: AnimatedSprite2D = $HBoxContainer/ButtonBrawlerGirl/AnimatedBrawlerGirl
@onready var animated_long_tail: AnimatedSprite2D = $HBoxContainer/ButtonLongTail/AnimatedLongTail

@onready var button_brawler_girl: Button = $HBoxContainer/ButtonBrawlerGirl
@onready var button_long_tail: Button = $HBoxContainer/ButtonLongTail

# @onready var select_1: AudioStreamPlayer = $HBoxContainer/ButtonBrawlerGirl/Select1
# @onready var select_2: AudioStreamPlayer = $HBoxContainer/ButtonLongTail/Select2

enum eCharacter { BRAWLER_GIRL, LONG_TAIL }

var selected_character: eCharacter = eCharacter.BRAWLER_GIRL
	
func _ready() -> void:
	# Set the initial selection when the scene is ready
	update_selection()

func _input(event: InputEvent) -> void:
	if not Global.screen_transition.in_transition:
		if event is InputEventKey and event.pressed:
			if Input.is_action_just_pressed("ui_left"):
				select_character(-1)
			elif Input.is_action_just_pressed("ui_right"):
				select_character(1)
			elif Input.is_action_just_pressed("ui_accept"):
				choose_character()

# Change the selected character based on direction
func select_character(direction: int) -> void:
	# Wrap around between BRAWLER_GIRL (0) and LONG_TAIL (1)
	if direction == 1:
		if selected_character == eCharacter.BRAWLER_GIRL:
			selected_character = eCharacter.LONG_TAIL
		else:
			selected_character = eCharacter.BRAWLER_GIRL
	elif direction == -1:
		if selected_character == eCharacter.LONG_TAIL:
			selected_character = eCharacter.BRAWLER_GIRL
		else:
			selected_character = eCharacter.LONG_TAIL

	update_selection()

# Update animations and visual effects based on the selected character
func update_selection() -> void:
	var highlight_color = Color(1, 1, 1)
	var normal_color = Color(0.4, 0.4, 0.4)

	if selected_character == eCharacter.BRAWLER_GIRL:
		animated_brawler_girl.play()
		animated_long_tail.pause()
		button_brawler_girl.modulate = highlight_color
		button_long_tail.modulate = normal_color
	else:
		animated_brawler_girl.pause()
		animated_long_tail.play()
		button_long_tail.modulate = highlight_color
		button_brawler_girl.modulate = normal_color

func choose_character() -> void:
	if selected_character == eCharacter.BRAWLER_GIRL:
		Global.player_resource = preload("res://scripts/resources/brawler_girl.tres")
	else:
		Global.player_resource = preload("res://scripts/resources/long_tail.tres")
		
	# Screen transition
	Global.screen_transition.transition(next_scene, transition_type)
