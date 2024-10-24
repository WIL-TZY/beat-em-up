extends CharacterBody3D

const SPEED := 5.0
const JUMP_FORCE := 4.5
const GRAVITY := 9.8

var motion := Vector3() # Creates a Vector3(0, 0, 0) object
var animation := ""

@onready var sprite:Sprite3D = $Sprite3D
@onready var animator:AnimationPlayer = $AnimationPlayer
@onready var spd := SPEED

func _process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		motion.y -= GRAVITY * delta
		
	# Movement
	motion.x = Input.get_axis("move_left", "move_right") * spd
	motion.z = Input.get_axis("move_up", "move_down") * spd
	
	# Jump
	if Input.is_action_just_pressed("jump"):
		motion.y = JUMP_FORCE
	
	flip()
		
# Because move_and_slide() works with physics
func _physics_process(delta: float) -> void:
	motion = move_and_slide(motion, Vector3.UP)

func flip() -> void:
	if motion.x != 0:
		sprite.flip_h = false if motion.x > 0 else true
