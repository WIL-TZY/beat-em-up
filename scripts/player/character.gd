class_name Character extends CharacterBody3D

enum StateMachine { IDLE, WALK, JUMP, FALL }

@export var speed := 2
@export var jump_force := 5

var state : StateMachine = StateMachine.IDLE
var enter_state : bool = true
var gravity : float = 9.8

@onready var animated_sprite : AnimatedSprite3D = $AnimatedSprite
@onready var shadow : Sprite3D = $Shadow

# Get input (read-only)
var input : Vector2: 
	get: return Input.get_vector("move_left", "move_right", "move_up", "move_down") * speed

var jump: bool:
	get: return Input.is_action_just_pressed("jump")

func _physics_process(delta: float) -> void:
	match state:
		StateMachine.IDLE: 		__idle()
		StateMachine.WALK: 		__walk()
		StateMachine.JUMP: 		__jump()
		StateMachine.FALL: 		__fall()

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
func __idle() 	-> void: pass
func __walk() 	-> void: pass
func __jump() 	-> void: pass
func __fall() 	-> void: pass

### MOVE & IDLE
func __movement() -> void:
	velocity.x = input.x
	velocity.z = input.y
	
func __stop_movement() -> void:
	velocity.x = 0
	velocity.z = 0

func __flip() -> void:
	if input.x:
		animated_sprite.flip_h = true if input.x < 0 else false

### JUMP
func __set_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
