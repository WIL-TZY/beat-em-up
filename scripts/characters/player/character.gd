class_name Character extends CharacterBody3D

enum StateMachine { IDLE, WALK, JUMP, FALL, JAB, PUNCH, KICK, KICK_AIR, HURT, DIED }
enum eChara { BRAWLER_GIRL, LONG_TAIL }

# Get player properties
@export var properties: CharacterData:
	get:
		if Global.player_resource != null:
			return Global.player_resource
		else:
			return properties

const CAMERA_OFFSET : float = 5.0

var state : StateMachine = StateMachine.IDLE
var chara : eChara = eChara.BRAWLER_GIRL
var enter_state : bool = true
var gravity : float = 9.8
var in_attack : bool = false
var dead : bool = false
var pickup : bool = false

# Preload the character scenes
var brawler_girl_scene : PackedScene = preload("res://scenes/prefab/animations/brawler_girl.tscn")
var longtail_scene : PackedScene = preload("res://scenes/prefab/animations/long_tail.tscn")

# The dynamic sprite node
var animated_sprite : AnimatedSprite3D = null

@onready var hp_max := properties.hp
@onready var shadow : Sprite3D = $Shadow
@onready var attack: Area3D = $Attack
@onready var attack_collision: CollisionShape3D = $Attack/AttackCollision
@onready var HUD: UI = Global.level.HUD
@onready var health_component: HealthComponent = $HealthComponent
@onready var camera: Camera3D = get_parent().get_node("Camera")
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@onready var debug_overlay = get_parent().get_node("DebugOverlay")

# Signals
signal __on_item_picked(item : Item)

# Encapsulation - Get input (read-only)
var input : Vector2: 
	get: return Input.get_vector("move_left", "move_right", "move_up", "move_down") * properties.speed

var jump: bool:
	get: return Input.is_action_just_pressed("jump")

var punch: bool:
	get: return Input.is_action_just_pressed("punch")

var kick: bool:
	get: return Input.is_action_just_pressed("kick")

# Runs only once
func _ready() -> void:
	# Instantiate the character sprite based on the player's selection
	if Global.player_resource == preload("res://scripts/resources/brawler_girl.tres"):
		chara = eChara.BRAWLER_GIRL
		animated_sprite = brawler_girl_scene.instantiate()
	elif Global.player_resource == preload("res://scripts/resources/long_tail.tres"):
		chara = eChara.LONG_TAIL
		animated_sprite = longtail_scene.instantiate()
	else:
		print("No valid player resource selected.")
		return

	# Add the scene to the scene tree
	add_child(animated_sprite)

	health_component.hp = properties.hp
	health_component.hp_max = hp_max
	
	# Connect signals
	health_component.__on_damage.connect(func(_hp: float): 
		audio_stream_player.stream = load("res://assets/sound/collision.wav")
		audio_stream_player.play()
		__change_state(StateMachine.HURT)
	)
	
	health_component.__on_dead.connect(func(): __change_state(StateMachine.DIED))
	__on_item_picked.connect(func(__item: Item): __get_item(__item))
	health_component.__on_recover.connect(func(health: float): print("Recovered " + str(health) + " HP"))
	
	# Detects collision with the enemy's hitbox component
	attack.area_entered.connect(func(hitbox: HitboxComponent):
		# print(hitbox.get_parent().name)
		hitbox.__take_damage(properties.strength)
	)

	# Update HUD
	HUD.__hud_update_player(properties) # Setup Player Character
	HUD.__hud_update_health(properties.hp)
	
	# animated_sprite.modulate = properties.color # Change color based on character
	
	## (DEBUG) Delete later
	debug_overlay.position = Vector2(20, 620)

# Runs every frame
func _physics_process(delta: float) -> void:
	match state:
		StateMachine.IDLE: __idle()
		StateMachine.WALK: __walk()
		StateMachine.JUMP: __jump()
		StateMachine.FALL: __fall()
		StateMachine.JAB: __jab()
		StateMachine.PUNCH: __punch()
		StateMachine.KICK: __kick()
		StateMachine.KICK_AIR: __kick_air()
		StateMachine.HURT: __hurt()
		StateMachine.DIED: __died()

	# Clamps the player position to the camera boundaries
	position.x = clamp(position.x, camera.position.x - CAMERA_OFFSET, camera.clamped_pos + CAMERA_OFFSET)
	__set_gravity(delta)
	move_and_slide() # Needs to be the last function call

### Functions
func __enter_state(animation: String) -> void:
	if enter_state:
		enter_state = false
		animated_sprite.play(animation)

func __change_state(new_state: StateMachine) -> void:
	if state != new_state:
		state = new_state
		enter_state = true
	
# Abstract methods (only updated in children)
func __idle() -> void: pass
func __walk() -> void: pass
func __jump() -> void: pass
func __fall() -> void: pass
func __jab() -> void: pass
func __punch() -> void: pass
func __kick() -> void: pass
func __kick_air() -> void: pass
func __hurt() -> void: pass
func __died() -> void: pass

### MOVE & IDLE
func __movement() -> void:
	velocity.x = input.x
	velocity.z = input.y
	
func __stop_movement() -> void:
	velocity.x = 0
	velocity.z = 0

func __flip() -> void:
	if input.x:
		animated_sprite.flip_h = true if input.x < 0 else false # Flip sprite
		attack.scale.x = -1 if input.x < 0 else 1 # Flip attack collision

### JUMP
func __set_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

### ATTACK
func __start_attack_collision() -> void:
	if not in_attack:
		in_attack = true
		attack_collision.disabled = false

func __end_attack_collision() -> void:
	if in_attack:
		in_attack = false
		attack_collision.disabled = true

func __get_item(__item: Item) -> void:
	# Item Pickup
	# print(__item)
	if __item:
		pickup = true
		health_component.__recover(__item.pickup())
		await get_tree().create_timer(0.3).timeout
		HUD.__hud_update_health(health_component.hp)
		__item.queue_free()
		pickup = false

############################# DEBUG #############################
# Call this function to update the debug overlay
func __update_debug_overlay(player_state: String) -> void:
	var debug_info = player_state
	
	debug_overlay.update_debug_info(debug_info)
	
func _process(_delta: float) -> void:
	## (DEBUG) Delete later
	__update_debug_overlay(str(StateMachine.keys()[state]))
