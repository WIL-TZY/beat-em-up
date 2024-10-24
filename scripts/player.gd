extends CharacterBody3D

const SPEED := 5.0
const JUMP_FORCE := 4.5
const GRAVITY := 9.8

@onready var sprite: Sprite3D = $Sprite3D
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var spd := SPEED

func _process(delta: float) -> void:
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
		
	# Handle movement
	velocity.x = Input.get_axis("move_left", "move_right") * spd
	velocity.z = Input.get_axis("move_up", "move_down") * spd
	
	# Handle jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_FORCE
	
	# Handle sprite flipping
	flip()

# Physics calculations should be in _physics_process
func _physics_process(delta: float) -> void:
	# Move the character
	move_and_slide()

func flip() -> void:
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0
