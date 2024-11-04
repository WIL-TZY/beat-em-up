extends CanvasLayer

@onready var animated_brawler_girl: AnimatedSprite2D = $Content/HBoxContainer/ButtonBrawlerGirl/AnimatedBrawlerGirl
@onready var animated_long_tail: AnimatedSprite2D = $Content/HBoxContainer/ButtonLongTail/AnimatedLongTail

@onready var select_1: AudioStreamPlayer = $Content/HBoxContainer/ButtonBrawlerGirl/Select1
@onready var select_2: AudioStreamPlayer = $Content/HBoxContainer/ButtonLongTail/Select2


func _on_button_brawler_girl_pressed() -> void:
	GameController.player_resource = preload("res://scripts/resources/brawler_girl.tres")
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func _on_button_long_tail_pressed() -> void:
	GameController.player_resource = preload("res://scripts/resources/long_tail.tres")
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

# On Mouse Hover Effect
func _on_button_brawler_girl_mouse_entered() -> void:
	animated_brawler_girl.play()
	# select_1.play()

func _on_button_brawler_girl_mouse_exited() -> void:
	animated_brawler_girl.pause()

func _on_button_long_tail_mouse_entered() -> void:
	animated_long_tail.play()
	# select_2.play()

func _on_button_long_tail_mouse_exited() -> void:
	animated_long_tail.pause()
