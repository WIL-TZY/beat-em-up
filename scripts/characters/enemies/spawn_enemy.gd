extends Area3D

enum sides { LEFT = 0, RIGHT = 1 }

@export var unlocked_at_area: float
@export var amount: int = 0
@export var enemies: Array[PackedScene]
@export var last_area: bool = false

@onready var camera: Camera3D = Global.level.camera

func _ready() -> void:
	# Connect signal to activate the functions when player collides
	body_entered.connect(func(_player: Player): _spawn_enemies())

func _spawn_enemies() -> void:
	for i in amount:
		# Returns a random value between 0 and the amount of enemies
		var enemy = enemies[randi() % enemies.size()].instantiate()
		# Takes a random position
		enemy.position = _set_enemy_random_position()
		# Add each enemy to the scene
		get_parent().add_child(enemy)

	Global.level.config_next_area(amount, unlocked_at_area)
	if last_area: Global.level.last_area = true
	# After the spawn is done, remove this node from the scene
	queue_free()

func _set_enemy_random_position() -> Vector3:
	var side = randi_range(sides.LEFT, sides.RIGHT)
	var new_position : Vector3
	
	match side:
		0: new_position = _get_camera_position(-7) # Left side
		1: new_position = _get_camera_position( 7) # Right side
	
	return new_position

func _get_camera_position(value: float) -> Vector3:
	return Vector3(camera.position.x + value, -0.525, randf_range(1.0, 4.0))
