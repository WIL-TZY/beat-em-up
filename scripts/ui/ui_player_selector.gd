extends CanvasLayer

func _on_button_brawler_girl_pressed() -> void:
	GameController.player_resource = preload("res://scripts/resources/brawler_girl.tres")
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func _on_button_long_tail_pressed() -> void:
	GameController.player_resource = preload("res://scripts/resources/long_tail.tres")
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
