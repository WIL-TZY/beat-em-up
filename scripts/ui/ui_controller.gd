class_name UI extends CanvasLayer

@onready var health: ProgressBar = $UIPlayer/Health

func __update_health(hp: float) -> void:
	health.value = hp
