extends Character

func __idle() -> void:
	__enter_state("idle")

func __walk() -> void:
	__enter_state("walk")
