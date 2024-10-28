extends Character

func __idle() -> void:
	__enter_state("idle")
	__stop_movement()
	if input: __change_state(StateMachine.WALK)

func __walk() -> void:
	__enter_state("walk")
	__movement()
	__flip()
	if not input: __change_state(StateMachine.IDLE)
