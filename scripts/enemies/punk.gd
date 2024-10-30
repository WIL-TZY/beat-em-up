extends Enemy

func _ready() -> void:
	state = EnemyState.IDLE

func __idle() -> void:
	__enter_state("idle")

func __walk() -> void:
	__enter_state("walk")
