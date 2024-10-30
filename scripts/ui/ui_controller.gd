class_name UI extends CanvasLayer

@onready var health: ProgressBar = $UIPlayer/Health

func __update_health(value: int) -> void:
	health.value = value
