class_name Enemy extends CharacterBody3D

enum EnemyState { IDLE, WALK, HURT, DOWN, UP, ATTACK, DIED }

@export var hp := 30
@export var strength := 3
@export var speed := 5.0

var state : EnemyState = EnemyState.IDLE
var enter_state : bool = true
var gravity : float = 9.8
var death : bool
var walk_timer : float
var face_right : bool
# var animation : String

@onready var animated_sprite : AnimatedSprite3D = $AnimatedSprite
@onready var timer_node: Timer = $Timer
@onready var player: Player = %Player

func _physics_process(delta: float) -> void:
	match state:
		EnemyState.IDLE: __idle()
		EnemyState.WALK: __walk(delta)
		
	__set_gravity(delta)

### Functions
func __set_animation(anim: String) -> void:
	animated_sprite.play(anim)

func __change_state(new_state: EnemyState) -> void:
	if state != new_state:
		state = new_state
		enter_state = true

# Abstract methods (only updated in children)
func __idle() -> void: pass
func __walk(_delta: float) -> void: pass

### MOVE & IDLE
func __movement() -> void:
	pass
	
func __stop_movement() -> void:
	velocity.x = 0
	velocity.z = 0

func __flip() -> void:
	# Check player direction
	face_right = player.transform.origin.x > transform.origin.x
	
	# Flip sprite
	animated_sprite.flip_h = face_right

	# Flip attack collision

### JUMP
func __set_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
