extends Enemy

var target_distance : Vector3 # Distance to player

func __idle() -> void:
	if enter_state:
		enter_state = false
		__set_animation("idle")

		# Wait a random amount of time in idle state
		timer_node.wait_time = randf_range(1, 2)
		timer_node.start()
		hurt_index = 0 # Reset hurt/down state

		# Automatically change to walk after timeout
		await timer_node.timeout
		__change_state(EnemyState.WALK)

func __walk(delta) -> void:
	if enter_state:
		enter_state = false

		# Wait a random amount of time in walk state
		timer_node.wait_time = randf_range(2, 4)
		timer_node.start()

		# Automatically change to idle after timeout
		await timer_node.timeout
		__change_state(EnemyState.IDLE)

	# =============================================
	#  ============== AI MOVEMENT ===============
	# This code executes before the timer timeout
	# =============================================	
	
	# Distance to the player position
	target_distance = player.transform.origin - self.transform.origin # Returns a Vector3
	
	# Horizontal Movement (depends on the player's horizontal direction)
	self.velocity.x = target_distance.x / abs(target_distance.x)
	
	# Walks for 1s and 2s
	walk_timer += delta
	if walk_timer >= randf_range(1, 2): 
		walk_timer = 0 # Reset timer
		# Vertical Movement
		if self.transform.origin.z < player.transform.origin.z:
			self.velocity.z = randi_range(0, 1) 
		else: 
			self.velocity.z = randi_range(-1, 0)

	# Attack the player when a certain distance is reached
	if abs(target_distance.x) < distance_attack:
		# Stops before reaching the player position
		self.velocity.x = 0
		
		# Start attack
		if abs(player.transform.origin.z - self.transform.origin.z) < 0.2:
			__change_state(EnemyState.ATTACK)

	__set_animation("idle" if not self.velocity else "walk")
	__flip() # Only flips towards the player while in walk state
	move_and_slide()

func __attack() -> void:
	if enter_state:
		enter_state = false
		__stop_movement()
		__start_attack_collision()
		__set_animation("punch")

		timer_node.wait_time = 0.5
		timer_node.start()

		await timer_node.timeout
		__end_attack_collision()
		__change_state(EnemyState.IDLE)

func __hurt() -> void:
	if enter_state:
		enter_state = false
		animated_sprite.play("hurt")

		timer_node.stop()
		timer_node.wait_time = randf_range(0.5, 1)
		timer_node.start()
			
		await timer_node.timeout
		__change_state(EnemyState.IDLE)

func __down() -> void:
	if enter_state:
		enter_state = false
		animated_sprite.play("down")
		
		# Can't receive damage while downed
		hitbox_collision.disabled = true
		
		# Upwards animation
		velocity.x = 1 if player.global_position.x < self.global_position.x else -1
		velocity.y = 3
		velocity.z = 0

		timer_node.stop()
		timer_node.wait_time = randf_range(1, 2)
		timer_node.start()
		await timer_node.timeout
		
		# Getting up animation
		__set_animation("up")
		await animated_sprite.animation_finished
		
		# Can receive damage after getting up
		hitbox_collision.disabled = true
		
		__change_state(EnemyState.IDLE)
	
	move_and_slide()

func __died() -> void:
	if enter_state:
		enter_state = false
		animated_sprite.play("died")
		timer_node.stop()
		
		# Death VFX (flicker sprite)
		for i in range(8):
			animated_sprite.visible = not animated_sprite.visible
			await get_tree().create_timer(0.1).timeout
		# Makes the enemy disappear after being defeated
		animated_sprite.hide()
		
		# Removes the node safely
		queue_free()

### DAMAGE
func __on_damage(_hp: float) -> void:
	# TO-DO: Atualizar a HUD do inimigo
	hurt_index += 1
	match hurt_index:
		1: __change_state(EnemyState.HURT)
		2: __change_state(EnemyState.DOWN)

# (DEBUG) Draw state
func _process(_delta: float) -> void:
	var label1 : Label = $"Debug Label1"
	var label2 : Label = $"Debug Label2"
	var text = str(EnemyState.keys()[state])
	label1.text = text
	# label2.text = str(target_distance)
	label2.text = "Hurt Index: " + str(hurt_index)
