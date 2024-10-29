extends Character

func __idle() -> void:
	__enter_state("idle")
	__stop_movement()
	if input: __change_state(StateMachine.WALK)
	if jump: __change_state(StateMachine.JUMP)
	if punch: __change_state(StateMachine.JAB)
	if kick: __change_state(StateMachine.KICK)

func __walk() -> void:
	__enter_state("walk")
	__movement()
	__flip()
	if not input: __change_state(StateMachine.IDLE)
	if jump: __change_state(StateMachine.JUMP)
	if punch: __change_state(StateMachine.JAB)
	if kick: __change_state(StateMachine.KICK)

func __jump() -> void:
	# Player can move while jumping
	__movement()
	# __flip()
	
	if enter_state:
		enter_state = false
		animated_sprite.play("jump")
		velocity.y = jump_force
		if shadow != null: shadow.hide()
		
	if velocity.y < 0: __change_state(StateMachine.FALL)

func __fall() -> void:
	__enter_state("fall")
	__movement()
	
	if is_on_floor(): 
		if shadow != null: shadow.show()
		__change_state(StateMachine.IDLE)

func __jab() -> void:
	__enter_state("jab")
	__start_attack_collision()
	__stop_movement()
	
	# Jab
	if animated_sprite.frame >= 3:
		__end_attack_collision()
		__change_state(StateMachine.IDLE)

	# Change to Punch state
	if (animated_sprite.frame >= 2) and punch:
		__end_attack_collision()
		__change_state(StateMachine.PUNCH)

func __punch() -> void:
	__enter_state("punch")
	__start_attack_collision()
	__stop_movement()
	
	if animated_sprite.frame >= 4:
		__end_attack_collision()
		__change_state(StateMachine.IDLE)
		
	# Punch sequence
	#if animated_sprite.frame >= 3:
	#	__change_state(StateMachine.JAB)

func __kick() -> void:
	__enter_state("kick")
	__start_attack_collision()
	__stop_movement()
	
	# Kick
	if animated_sprite.frame >= 6:
		__end_attack_collision()
		__change_state(StateMachine.IDLE)

	# Change to KICK_AIR state
	if (animated_sprite.frame >= 5) and kick:
		__end_attack_collision()
		__change_state(StateMachine.KICK_AIR)

func __kick_air() -> void:
	__enter_state("kick_air")
	__start_attack_collision()
	__stop_movement()
	
	if animated_sprite.frame >= 8:
		__end_attack_collision()
		__change_state(StateMachine.IDLE)

# (DEBUG) Draw state
func _process(_delta: float) -> void:
	var label : Label = $Label
	var text = str(StateMachine.keys()[state])
	label.text = text
