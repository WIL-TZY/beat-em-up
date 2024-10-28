class_name Character extends CharacterBody3D

enum StateMachine { IDLE, WALK }

@export var speed := 2
@export var jump_force := 5

var state : StateMachine = StateMachine.IDLE
var enter_state : bool = true

@onready var animated_sprite : AnimatedSprite3D = $AnimatedSprite

func _physics_process(_delta: float) -> void:
	match state:
		StateMachine.IDLE: __idle()
		StateMachine.WALK: __walk()

	move_and_slide()

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
