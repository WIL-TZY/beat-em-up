class_name Character extends CharacterBody3D

enum StateMachine { IDLE, WALK, JUMP, FALL, JAB, PUNCH, KICK, KICK_AIR }

@export var speed := 2
@export var jump_force := 5

var state : StateMachine = StateMachine.IDLE
var enter_state : bool = true
var gravity : float = 9.8
var in_attack : bool = false

@onready var animated_sprite : AnimatedSprite3D = $AnimatedSprite
@onready var shadow : Sprite3D = $Shadow
@onready var attack_collision: CollisionShape3D = $Attack/AttackCollision

# Encapsulation - Get input (read-only)
var input : Vector2: 
	get: return Input.get_vector("move_left", "move_right", "move_up", "move_down") * speed

var jump: bool:
	get: return Input.is_action_just_pressed("jump")

var punch: bool:
	get: return Input.is_action_just_pressed("punch")

var kick: bool:
	get: return Input.is_action_just_pressed("kick")

func _ready() -> void:
	# DEBUG BODY
	$Attack.body_entered.connect(func(body: Node3D):
		print(body.name)
	)

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

	__set_gravity(delta)
	move_and_slide()

### Functions
func __enter_state(animation: String) -> void:
	if enter_state:
		enter_state = false
		animated_sprite.play(animation)
		
func __change_state(new_state: StateMachine) -> void:
	if state != new_state:
		state = new_state
		enter_state = true
	
# Abstract methods (only updated in child)
func __idle() -> void: pass
func __walk() -> void: pass
func __jump() -> void: pass
func __fall() -> void: pass
func __jab() -> void: pass
func __punch() -> void: pass
func __kick() -> void: pass
func __kick_air() -> void: pass

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
		$Attack.scale.x = -1 if input.x < 0 else 1 # Flip attack collision

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
