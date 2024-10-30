class_name Enemy extends CharacterBody3D

enum EnemyState { IDLE, WALK, HURT, DOWN, UP, ATTACK, DIED }

@export var hp := 30
@export var strength := 3
@export var speed := 5.0

var state : EnemyState = EnemyState.IDLE
var enter_state : bool = true

@onready var animated_sprite : AnimatedSprite3D = $AnimatedSprite

func _physics_process(_delta: float) -> void:
	match state:
		EnemyState.IDLE: __idle()
		EnemyState.WALK: __walk()

### Functions
func __enter_state(animation: String) -> void:
	if enter_state:
		enter_state = false
		animated_sprite.play(animation)

func __change_state(new_state: EnemyState) -> void:
	if state != new_state:
		state = new_state
		enter_state = true

# Abstract methods (only updated in children)
func __idle() -> void: pass
func __walk() -> void: pass
