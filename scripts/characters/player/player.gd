class_name Player extends Character

func __idle() -> void:
	if dead: return
	
	__enter_state("idle")
	__stop_movement()
	
	
	if input: __change_state(StateMachine.WALK)
	if jump: __change_state(StateMachine.JUMP)
	if punch: __change_state(StateMachine.JAB)
	if kick: __change_state(StateMachine.KICK)

func __walk() -> void:
	if dead: return
	
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
		velocity.y = properties.jump_force
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
	__stop_movement()

	# Jab
	if animated_sprite.frame == 1: __start_attack_collision()
	# Change to Punch state
	if animated_sprite.frame >= 2: 
		__end_attack_collision()
		# Goes to next attack
		if punch: __change_state(StateMachine.PUNCH)
	# Back to idle
	if animated_sprite.frame >= 4: __change_state(StateMachine.IDLE)

func __punch() -> void:
	__enter_state("punch")
	__stop_movement()
	
	# Punch
	if animated_sprite.frame == 1: __start_attack_collision()
	if animated_sprite.frame >= 2: __end_attack_collision()
	if animated_sprite.frame >= 4: __change_state(StateMachine.IDLE)

	# Punch sequence
	#if animated_sprite.frame >= 3:
	#	__change_state(StateMachine.JAB)

func __kick() -> void:
	__enter_state("kick")
	__stop_movement()
	
	# Kick
	if animated_sprite.frame == 3: __start_attack_collision()
	# Change to Kick Air state
	if animated_sprite.frame >= 5: 
		__end_attack_collision()
		# Goes to next attack
		if kick: __change_state(StateMachine.KICK_AIR)
	# Back to idle
	if animated_sprite.frame >= 6: __change_state(StateMachine.IDLE)

func __kick_air() -> void:
	__enter_state("kick_air")
	__stop_movement()
	
	# Kick
	if animated_sprite.frame == 2: __start_attack_collision()
	if animated_sprite.frame >= 4: __end_attack_collision()
	if animated_sprite.frame >= 8: __change_state(StateMachine.IDLE)

func __hurt() -> void:
	if enter_state:
		enter_state = false
		animated_sprite.play("hurt")
		__stop_movement()
		
		# Update UI
		HUD.__hud_update_health(health_component.hp)
	
	# Wait 0.5 seconds before changing state
	await get_tree().create_timer(0.5).timeout
	__change_state(StateMachine.IDLE)

func __died() -> void:
	if enter_state:
		enter_state = false
		animated_sprite.play("hurt")
		dead = true
		__stop_movement()
		
		# Update UI
		HUD.__hud_update_health(health_component.hp)
		
		# Death VFX (flicker sprite)
		for i in range(8):
			animated_sprite.visible = not animated_sprite.visible
			await get_tree().create_timer(0.1).timeout

		# Makes the player disappear after being defeated
		animated_sprite.hide()
		if shadow != null: shadow.hide()
		
		# Change back to menu after 2 seconds
		await get_tree().create_timer(2).timeout
		
		# Screen transition
		Global.screen_transition.transition(
			"res://scenes/screens/player_selector.tscn", 
			Global.screen_transition.TransitionType.PIXELATE
		)
		
