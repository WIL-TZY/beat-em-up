class_name LevelController extends Node

var enemies := 0
var unlocked_at_area := 0.0

func enemy_died() -> void:
	enemies -= 1
	if enemies <= 0:
		_next_area(unlocked_at_area)

func _next_area(camera_limit: float) -> void:
	GameController.camera.set_camera_limit(camera_limit)

func config_next_area(amount: int, unlocked: float) -> void:
	enemies = amount
	unlocked_at_area = unlocked
