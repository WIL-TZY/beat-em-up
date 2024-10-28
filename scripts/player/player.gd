extends Character

func __idle() -> void:
	__enter_state("idle")
	__stop_movement()
	if input: __change_state(StateMachine.WALK)
	if jump: __change_state(StateMachine.JUMP)

func __walk() -> void:
	__enter_state("walk")
	__movement()
	__flip()
	if not input: __change_state(StateMachine.IDLE)
	if jump: __change_state(StateMachine.JUMP)

func __jump() -> void:
	# Player can move while jumping
	__movement()
	# __flip()
	
	if enter_state:
		enter_state = false
		animated_sprite.play("jump")
		velocity.y = jump_force
		if shadow != null: shadow.hide()
		
		# Wait 0.2 seconds
		await get_tree().create_timer(0.2).timeout 
	
	# Only runs this block after waiting for 0.2 seconds
	if is_on_floor(): 
		if shadow != null: shadow.show()
		__change_state(StateMachine.IDLE)
