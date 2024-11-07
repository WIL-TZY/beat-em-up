class_name LevelController extends Node

# Singleton script

# For debug
static var enemies: Array[Enemy]

@export var _player: Player 
@export var _camera: Camera3D
@export var _HUD: UI

# Static variables persist across instances and scene changes
# ideal for global data management, utility functions, and ensuring a single data copy 
# These variables can be accessed directly from the class without creating a new instance
static var player: Player 
static var camera: Camera3D
static var HUD: UI
static var player_resource: CharacterData

# Runs before ready
func _enter_tree() -> void:
	player = _player
	camera = _camera
	HUD = _HUD

## TO-DO: This controller should handles connection between nodes in the level scene
